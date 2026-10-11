# Bloomly

Interaktivna web aplikacija za učenje programskog jezika Python, sa sadržajem
strukturiranim prema Bloomovoj taksonomiji obrazovnih ciljeva. Zadatci koji
zahtijevaju pisanje koda izvršavaju se na vlastitom poslužitelju, točnost se
utvrđuje determinističkom usporedbom ispisa, a jezični model objašnjava
utvrđeni ishod.

Diplomski rad, Sveučilište u Mostaru, Fakultet prirodoslovno-matematičkih i
odgojnih znanosti, studij Informatike.

---

## 1. Korištene tehnologije i verzije

| Komponenta | Verzija |
|---|---|
| Flutter | 3.44.8 (stable) |
| Dart | 3.12.2 |
| supabase_flutter | ^2.5.6 |
| sentry_flutter | ^9.16.0 |
| http | ^1.2.2 |
| Python (izvršavanje korisničkog koda) | 3.12.0 |
| Piston | ghcr.io/engineer-man/piston (najnovija slika) |
| nginx | nginx:alpine |
| Gemini model | gemini-3.6-flash |

Postavke generiranja (`temperature`, `topP`, `topK`, `maxOutputTokens`) nisu
mijenjane, nego se koriste zadane vrijednosti modela; u zahtjevu se šalje
isključivo polje `contents`.

---

## 2. Struktura projekta

```
moja_app/
├── lib/
│   ├── models/              sadržaj lekcija (varijable, liste, ifelse)
│   ├── services/            Supabase, Piston, Gemini, usporedba ispisa, napredak
│   ├── widgets/
│   └── *.dart               ekrani aplikacije
├── supabase/functions/
│   ├── ocijeni-kod/         poslužiteljska funkcija: poziv Gemini modela
│   └── izvrsi-kod/          poslužiteljska funkcija: poziv Piston poslužitelja
├── testiranje/              testne skripte i rezultati (Python)
└── pubspec.yaml
```

---

## 3. Pokretanje aplikacije

```bash
flutter pub get
flutter run -d chrome --web-port=3000
```

Port 3000 je obavezan, budući da je ta adresa upisana među dopuštene adrese za
preusmjeravanje u Supabase postavkama (prijava i resetiranje lozinke).

Za rješavanje zadataka s kodom potrebna je prijava, jer poslužiteljske funkcije
prihvaćaju isključivo zahtjeve prijavljenih korisnika. Ograničenje je 60 AI
zahtjeva po korisniku na sat.

U repozitoriju se ne nalazi nijedan tajni ključ. Aplikacija sadrži samo javni
(anon/publishable) Supabase ključ, koji je namijenjen klijentskoj uporabi i
zaštićen je pravilima pristupa na razini redaka.

---

## 4. Poslužiteljske funkcije

Tajne se postavljaju naredbom `supabase secrets set` i čuvaju se isključivo na
poslužitelju:

```bash
supabase secrets set GEMINI_API_KEY=<tajni ključ Gemini API-ja>
supabase secrets set PISTON_URL=http://<adresa>:2001/api/v2/execute
supabase secrets set PISTON_TOKEN=<tajni niz za pristup Pistonu>

supabase functions deploy ocijeni-kod
supabase functions deploy izvrsi-kod
```

---

## 5. Poslužitelj za izvršavanje koda

`docker-compose.yml` i `nginx.conf` nalaze se u mapi `posluzitelj/`.
Ograničenja izvršavanja postavljena su izričito:

| Postavka | Vrijednost |
|---|---|
| PISTON_RUN_TIMEOUT | 5000 ms |
| PISTON_RUN_CPU_TIME | 5000 ms |
| PISTON_COMPILE_TIMEOUT | 10000 ms |
| PISTON_RUN_MEMORY_LIMIT | 256 MB |
| PISTON_OUTPUT_MAX_SIZE | 65536 B |
| PISTON_MAX_PROCESS_COUNT | 64 |
| PISTON_MAX_OPEN_FILES | 2048 |
| PISTON_DISABLE_NETWORKING | true |

Pristup poslužitelju moguć je samo uz ispravno zaglavlje `X-Piston-Token`;
svaki drugi zahtjev odbija se sa statusom 403. Broj zahtjeva s iste izvorne
adrese ograničen je na deset u minuti.

Pokretanje:

```bash
docker compose down && docker compose up -d
```

---

## 6. Baza podataka

SQL za tablicu `ai_zahtjevi` i pripadajuća pravila nalazi se u `baza/ai_zahtjevi.sql`.
Tablica `progress` ima tri pravila na razini redaka (čitanje, upis, izmjena),
sva uvjetovana podudaranjem `auth.uid() = user_id`. Pravilo za brisanje nije
definirano, pa brisanje nije dopušteno.

---

## 7. Testiranje

U mapi `testiranje/`:

| Datoteka | Namjena |
|---|---|
| `testni_skup.py` | 28 testnih rješenja s unaprijed utvrđenim očekivanim ishodom |
| `testiranje.py` | provjera ishoda, AI objašnjenja, vremena odziva i tokena |
| `granice_pistona.py` | ponašanje pri prekoračenju ograničenja izvršavanja |
| `provjera_rls.py` | provjera pravila pristupa podacima o napretku |
| `rezultati.csv`, `granice.csv`, `rls.csv` | rezultati provedenih provjera |

Prije pokretanja u skripte treba upisati vlastiti Gemini ključ, tajni niz za
Piston te podatke dvaju korisničkih računa. Te vrijednosti nisu dio repozitorija.

```bash
pip install requests
python testiranje.py
```

---

## 8. Podaci koji se šalju vanjskim uslugama

**Gemini** prima tekst zadatka, referentno rješenje, očekivani ispis, kod koji
je korisnik napisao, stvarni ispis tog koda, poruku interpretera i utvrđeni
ishod provjere. Ne šalju se identitet korisnika, adresa e-pošte ni identifikator
sesije.

**Sentry** prima podatke o pogreškama u radu same aplikacije: vrstu i poruku
iznimke, stog poziva, naziv komponente u kojoj je pogreška nastala te podatke o
pregledniku i operacijskom sustavu. Korisnički kod i sadržaj lekcija ne šalju
se, a slanje podataka o korisniku nije uključeno (`sendDefaultPii` ostaje
isključen, što je zadana vrijednost). Ključevi i pristupni tokeni ne pojavljuju
se u zapisima, budući da se u klijentskoj aplikaciji ne nalaze.
