// lib/models/ifelse/bloom34.dart
//
// Tema IF/ELSE — Bloom 3-4 (Primjena/Analiza)
// Uvjeti i petlje unutar objekata i struktura. Uparivanje/hijerarhija.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Uvjeti unutar metoda klase
// ---------------------------------------------------------------------

final LessonSection ifB34S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Uvjetna logika unutar metode',
      content: '''
Metode klasa često sadrže uvjete koji reagiraju na stanje objekta (njegove atribute):

class BankovniRacun:
    def __init__(self, stanje):
        self.stanje = stanje

    def podigni(self, iznos):
        if iznos <= 0:
            print("Iznos mora biti pozitivan")
        elif iznos > self.stanje:
            print("Nedovoljno sredstava")
        else:
            self.stanje -= iznos
            print(f"Podignuto {iznos}, novo stanje: {self.stanje}")

racun = BankovniRacun(100)
racun.podigni(150)   # Nedovoljno sredstava
racun.podigni(50)    # Podignuto 50, novo stanje: 50

Uvjeti unutar metoda kontroliraju KAKO se objekt ponaša u različitim situacijama - ovo je temelj "poslovne logike" u stvarnim aplikacijama.
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Validacija podataka pri stvaranju objekta',
      content: '''
Uvjeti se često koriste u __init__ konstruktoru za provjeru valjanosti ulaznih podataka PRIJE nego se objekt uopće stvori:

class Student:
    def __init__(self, ime, godina):
        if godina < 1 or godina > 5:
            raise ValueError("Godina mora biti između 1 i 5")
        self.ime = ime
        self.godina = godina

try:
    s = Student("Ana", 10)
except ValueError as e:
    print(e)   # Godina mora biti između 1 i 5

Ovo sprječava stvaranje objekata s nevažećim stanjem - bolje spriječiti grešku odmah pri stvaranju, nego je otkriti kasnije negdje drugdje u kodu.
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Uvjetno ponašanje - polimorfizam kroz if',
      content: '''
Prije uvođenja pravog polimorfizma (koji se uči u naprednijim kolegijima), uvjeti unutar metode mogu simulirati različito ponašanje ovisno o TIPU objekta:

class Oblik:
    def __init__(self, tip, a, b=0):
        self.tip = tip
        self.a = a
        self.b = b

    def povrsina(self):
        if self.tip == "kvadrat":
            return self.a ** 2
        elif self.tip == "pravokutnik":
            return self.a * self.b
        elif self.tip == "krug":
            return 3.14159 * self.a ** 2
        else:
            raise ValueError("Nepoznat tip oblika")

k = Oblik("krug", 5)
print(k.povrsina())   # 78.53975

Napomena: u praksi je BOLJE koristiti nasljeđivanje (svaki oblik svoja klasa) umjesto niza if/elif - ovo je ipak koristan međukorak za razumijevanje.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Uvjeti za kontrolu stanja objekta',
      content: '''
Objekti često imaju "stanje" koje se mijenja tijekom vremena, a uvjeti kontroliraju dopuštene prijelaze:

class Narudzba:
    def __init__(self):
        self.status = "na_cekanju"

    def potvrdi(self):
        if self.status == "na_cekanju":
            self.status = "potvrdeno"
        else:
            print("Ne može se potvrditi iz trenutnog stanja")

    def otkazi(self):
        if self.status in ("na_cekanju", "potvrdeno"):
            self.status = "otkazano"
        else:
            print("Ne može se otkazati")

n = Narudzba()
n.potvrdi()
print(n.status)   # potvrdeno

Ovaj obrazac (uvjeti koji kontroliraju dopuštene promjene stanja) naziva se state machine (konačni automat) - detaljnije u Bloom 5-6 razini ove teme.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Usporedba objekata pomoću uvjeta',
      content: '''
Python omogućuje definiranje kako se uvjeti ponašaju za VLASTITE klase, pomoću posebnih metoda:

class Ocjena:
    def __init__(self, vrijednost):
        self.vrijednost = vrijednost

    def __eq__(self, other):
        return self.vrijednost == other.vrijednost

    def __lt__(self, other):
        return self.vrijednost < other.vrijednost

o1 = Ocjena(4)
o2 = Ocjena(5)
print(o1 == o2)   # False - koristi __eq__
print(o1 < o2)    # True - koristi __lt__

Ovime tvoji objekti mogu koristiti standardne operatore usporedbe (==, <, >) kao da su ugrađeni tipovi - napredna, ali korisna tehnika.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib34s1q1',
      type: QuestionType.matching,
      prompt: 'Upari pojam s njegovom svrhom.',
      matchPairs: {
        'Uvjet u __init__': 'Validacija podataka prije stvaranja objekta',
        'if/elif niz u metodi': 'Simulira različito ponašanje ovisno o tipu (prije pravog polimorfizma)',
        'Uvjet za promjenu status atributa': 'Kontrola dopuštenih prijelaza stanja',
        '__eq__ i __lt__': 'Omogućuju == i < za vlastite objekte',
      },
    ),
    Question(
      id: 'ib34s1q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake obrade racun.podigni(150) za BankovniRacun sa stanjem 100.',
      hierarchyItems: [
        'Provjeri je li iznos <= 0',
        'Provjeri je li iznos > self.stanje',
        'Uvjet je True (150 > 100) - ispiši "Nedovoljno sredstava"',
        'self.stanje ostaje NEPROMIJENJEN',
      ],
    ),
    Question(
      id: 'ib34s1q3',
      type: QuestionType.matching,
      prompt: 'Upari narudžbu operaciju s ishodom, za Narudzba() koja počinje sa status="na_cekanju".',
      matchPairs: {
        'n.potvrdi()': 'status postaje "potvrdeno"',
        'n.otkazi() nakon potvrdi()': 'status postaje "otkazano"',
        'n.potvrdi() dva puta zaredom': 'Drugi poziv ispisuje poruku o grešci',
        'n.status na početku': '"na_cekanju"',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Petlje unutar metoda klase
// ---------------------------------------------------------------------

final LessonSection ifB34S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Petlja koja obrađuje kolekciju atributa',
      content: '''
Metode klase često koriste petlju za obradu liste koju objekt posjeduje:

class Razred:
    def __init__(self):
        self.ocjene = []

    def dodaj_ocjenu(self, ocjena):
        self.ocjene.append(ocjena)

    def prosjek(self):
        if not self.ocjene:
            return 0
        suma = 0
        for ocjena in self.ocjene:
            suma += ocjena
        return suma / len(self.ocjene)

r = Razred()
r.dodaj_ocjenu(5)
r.dodaj_ocjenu(3)
print(r.prosjek())   # 4.0

Petlja unutar metode ostaje "sakrivena" od korisnika klase - on samo poziva prosjek() i dobiva rezultat, bez da zna KAKO se izračun izvodi.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Petlja s ranim izlaskom unutar metode',
      content: '''
Kombinacija petlje i uvjeta unutar metode za pretragu:

class Razred:
    def __init__(self):
        self.studenti = []

    def pronadi_studenta(self, ime):
        for student in self.studenti:
            if student["ime"] == ime:
                return student
        return None

r = Razred()
r.studenti = [{"ime": "Ana"}, {"ime": "Marko"}]
print(r.pronadi_studenta("Marko"))   # {"ime": "Marko"}
print(r.pronadi_studenta("Ivan"))    # None

return unutar petlje odmah završava metodu čim se pronađe traženo - nema potrebe za dodatnom zastavicom (flag varijablom).
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Petlja koja poziva metode drugih objekata',
      content: '''
Kad lista sadrži objekte (ne "gole" podatke), petlja može pozivati NJIHOVE metode:

class Student:
    def __init__(self, ime, ocjene):
        self.ime = ime
        self.ocjene = ocjene

    def prosjek(self):
        return sum(self.ocjene) / len(self.ocjene)

class Razred:
    def __init__(self):
        self.studenti = []

    def prosjek_razreda(self):
        if not self.studenti:
            return 0
        ukupno = 0
        for student in self.studenti:
            ukupno += student.prosjek()   # poziva metodu SVAKOG studenta
        return ukupno / len(self.studenti)

Ovo je čest obrazac - klasa koja "orkestrira" (koordinira) svoje objekte pozivajući njihove metode unutar petlje.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'While petlja za čekanje na stanje',
      content: '''
while petlja se koristi kad broj ponavljanja NIJE unaprijed poznat, npr. čekanje da stanje objekta postane valjano:

class Igra:
    def __init__(self):
        self.zivoti = 3

    def izgubi_zivot(self):
        self.zivoti -= 1

igra = Igra()
while igra.zivoti > 0:
    print(f"Preostalo života: {igra.zivoti}")
    igra.izgubi_zivot()
print("Igra gotova")

Ovakav obrazac (while petlja koja provjerava atribut objekta) je temelj za implementaciju igara, simulacija i sličnih programa s "petljom događaja".
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Rekapitulacija - kontrola toka unutar objekata',
      content: '''
Ova sekcija pokazala je kako se if/petlje koriste UNUTAR metoda klasa:

1. Uvjeti unutar metode kontroliraju kako objekt reagira na pozive
2. Petlje unutar metode obrađuju kolekciju koju objekt posjeduje (self.lista)
3. return unutar petlje omogućuje rani izlazak pri pretrazi
4. Metoda može pozivati metode DRUGIH objekata unutar petlje

Ovo pokazuje kako se osnovni koncepti (if, for, while) prirodno kombiniraju s OOP-om da bi se organizirao složeniji, čitljiviji kod.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib34s2q1',
      type: QuestionType.matching,
      prompt: 'Upari metodu klase Razred s njenim obrascem.',
      matchPairs: {
        'prosjek()': 'Petlja koja zbraja atribut self.ocjene',
        'pronadi_studenta(ime)': 'Petlja s ranim return unutar if uvjeta',
        'prosjek_razreda()': 'Petlja koja poziva metode drugih objekata',
        'if not self.ocjene': 'Sigurnosna provjera prije dijeljenja',
      },
    ),
    Question(
      id: 'ib34s2q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake metode pronadi_studenta("Marko") za listu [{"ime":"Ana"},{"ime":"Marko"}].',
      hierarchyItems: [
        'Uđi u petlju, provjeri prvi element (Ana)',
        'Uvjet student["ime"]=="Marko" je False za Anu, nastavi',
        'Provjeri drugi element (Marko)',
        'Uvjet je True - odmah vrati taj element preko return',
      ],
    ),
    Question(
      id: 'ib34s2q3',
      type: QuestionType.matching,
      prompt: 'Upari koncept s primjerom iz koda.',
      matchPairs: {
        'while igra.zivoti > 0': 'Petlja koja ovisi o atributu objekta',
        'return None nakon petlje': 'Signal da traženi element nije pronađen',
        'ukupno += student.prosjek()': 'Poziv metode DRUGOG objekta unutar petlje',
        'self.studenti': 'Lista koju klasa Razred posjeduje i obrađuje',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Konačni automati (state machines)
// ---------------------------------------------------------------------

final LessonSection ifB34S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Što je konačni automat (state machine)?',
      content: '''
Konačni automat je model gdje objekt uvijek ima TOČNO JEDNO od unaprijed definiranih stanja, a uvjeti kontroliraju DOPUŠTENE prijelaze između njih:

class Semafor:
    def __init__(self):
        self.stanje = "crveno"

    def sljedece(self):
        if self.stanje == "crveno":
            self.stanje = "zeleno"
        elif self.stanje == "zeleno":
            self.stanje = "zuto"
        elif self.stanje == "zuto":
            self.stanje = "crveno"

s = Semafor()
for _ in range(4):
    print(s.stanje)
    s.sljedece()
# crveno, zeleno, zuto, crveno

Semafor je klasičan primjer - stanja se mijenjaju u FIKSNOM, predvidljivom redoslijedu, kontroliranom isključivo if/elif uvjetima.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Dijagram stanja kao popis dopuštenih prijelaza',
      content: '''
Složeniji konačni automat može koristiti rječnik za definiranje dopuštenih prijelaza, umjesto niza if/elif:

prijelazi = {
    "na_cekanju": ["potvrdeno", "otkazano"],
    "potvrdeno": ["poslano", "otkazano"],
    "poslano": ["dostavljeno"],
    "dostavljeno": [],
    "otkazano": [],
}

def promijeni_stanje(trenutno, novo):
    if novo in prijelazi[trenutno]:
        return novo
    else:
        print(f"Prijelaz iz {trenutno} u {novo} nije dopušten")
        return trenutno

stanje = promijeni_stanje("na_cekanju", "poslano")
print(stanje)   # na_cekanju (nedopušteno, ostaje isto)

Ovaj pristup (rječnik dopuštenih prijelaza) je čitljiviji i lakši za proširivanje od dugog niza if/elif uvjeta.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'match-case - moderna alternativa if/elif nizu',
      content: '''
Python 3.10+ uvodi match-case, strukturiraniju alternativu dugom if/elif nizu za provjeru VIŠE mogućih vrijednosti:

def opis_statusa(status):
    match status:
        case "na_cekanju":
            return "Čeka obradu"
        case "potvrdeno":
            return "Potvrđeno, čeka slanje"
        case "poslano":
            return "U dostavi"
        case _:
            return "Nepoznat status"

print(opis_statusa("poslano"))   # U dostavi

case _ je "catch-all" (hvata sve preostalo), ekvivalent else grani. match-case je čitljiviji kad uspoređuješ JEDNU varijablu s više mogućih točnih vrijednosti.
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Petlja koja simulira prolazak kroz stanja',
      content: '''
Kombinacija while petlje i state machine logike simulira kompletan "životni ciklus" objekta:

class Narudzba:
    def __init__(self):
        self.status = "na_cekanju"

    def sljedeci_korak(self):
        redoslijed = ["na_cekanju", "potvrdeno", "poslano", "dostavljeno"]
        trenutni_indeks = redoslijed.index(self.status)
        if trenutni_indeks < len(redoslijed) - 1:
            self.status = redoslijed[trenutni_indeks + 1]

n = Narudzba()
while n.status != "dostavljeno":
    print(n.status)
    n.sljedeci_korak()
print(n.status)   # dostavljeno

Ova petlja "gura" narudžbu kroz sva stanja dok ne dosegne konačno stanje - koristan obrazac za simulacije i testiranje poslovne logike.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Rekapitulacija - uvjeti kao pravila prijelaza',
      content: '''
Ova sekcija pokazala je kako if/elif (i njegova moderna alternativa match-case) modeliraju STANJA i njihove PRIJELAZE:

1. Konačni automat ima ograničen skup stanja i pravila prijelaza između njih
2. Rječnik dopuštenih prijelaza je čitljiviji od dugog if/elif niza
3. match-case je moderna alternativa za usporedbu jedne varijable s više vrijednosti
4. while petlja može simulirati kompletan prolazak kroz sva stanja

Ovaj obrazac (uvjeti kao pravila prijelaza) primjenjuje se svugdje gdje objekt prolazi kroz jasno definirane faze - narudžbe, korisnički računi, semafori, pa i tvoja Bloomly aplikacija (student prolazi kroz stranice/kvizove kao kroz stanja).
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib34s3q1',
      type: QuestionType.matching,
      prompt: 'Upari pojam s njegovim opisom.',
      matchPairs: {
        'Konačni automat': 'Objekt ima točno jedno od unaprijed definiranih stanja',
        'Rječnik dopuštenih prijelaza': 'Čitljivija alternativa dugom if/elif nizu',
        'match-case': 'Moderna Python sintaksa za usporedbu jedne varijable s više vrijednosti',
        'case _': 'Catch-all grana, ekvivalent else',
      },
    ),
    Question(
      id: 'ib34s3q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj stanja semafora kroz koja prolazi Semafor() nakon 3 poziva sljedece(), počevši od "crveno".',
      hierarchyItems: [
        'crveno (početno stanje)',
        'zeleno (nakon 1. poziva)',
        'zuto (nakon 2. poziva)',
        'crveno (nakon 3. poziva - vraća se na početak)',
      ],
    ),
    Question(
      id: 'ib34s3q3',
      type: QuestionType.matching,
      prompt: 'Upari status narudžbe s dopuštenim sljedećim stanjem prema prijelazi rječniku.',
      matchPairs: {
        '"na_cekanju"': 'Može ići u "potvrdeno" ili "otkazano"',
        '"potvrdeno"': 'Može ići u "poslano" ili "otkazano"',
        '"poslano"': 'Može ići samo u "dostavljeno"',
        '"dostavljeno"': 'Nema dopuštenih daljnjih prijelaza (prazna lista)',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Iteratori i vlastite petlje
// ---------------------------------------------------------------------

final LessonSection ifB34S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: '__iter__ i __next__ - kako for petlja stvarno radi',
      content: '''
Kad pišeš for x in kolekcija, Python "ispod haube" poziva posebne metode __iter__ i __next__. Možeš ih implementirati i za VLASTITU klasu:

class Brojac:
    def __init__(self, maks):
        self.trenutno = 0
        self.maks = maks

    def __iter__(self):
        return self

    def __next__(self):
        if self.trenutno >= self.maks:
            raise StopIteration
        self.trenutno += 1
        return self.trenutno

for broj in Brojac(3):
    print(broj)   # 1, 2, 3

Ovime tvoja klasa postaje "iterabilna" - može se koristiti u for petlji baš kao ugrađene liste i rječnici.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Generatorske funkcije - jednostavnija alternativa',
      content: '''
Umjesto pisanja cijele klase s __iter__/__next__, generatorska funkcija (koristi yield) postiže isto puno jednostavnije:

def brojac(maks):
    trenutno = 0
    while trenutno < maks:
        trenutno += 1
        yield trenutno

for broj in brojac(3):
    print(broj)   # 1, 2, 3

yield "pauzira" funkciju i vraća vrijednost, ali pamti gdje je stala - sljedeći poziv nastavlja OTKUD JE STALA, umjesto da počne ispočetka. Ovo je temelj generatora koje smo spominjali ranije.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'while True s uvjetnim break - petlja glavnog izbornika',
      content: '''
Čest obrazac u interaktivnim programima: petlja koja se ponavlja "zauvijek" dok korisnik eksplicitno ne odluči izaći:

def glavni_izbornik():
    while True:
        odabir = input("1) Start 2) Postavke 3) Izlaz: ")
        if odabir == "1":
            print("Pokrećem igru...")
        elif odabir == "2":
            print("Otvaram postavke...")
        elif odabir == "3":
            print("Izlazim...")
            break
        else:
            print("Nepoznata opcija")

while True: stvara petlju koja se NIKAD sama ne zaustavlja - jedini izlaz je eksplicitni break unutar uvjeta, kad korisnik odabere "Izlaz".
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Kombiniranje iteratora s uvjetima za filtriranje',
      content: '''
Generator može uključivati uvjet, filtrirajući koje vrijednosti "isporučuje":

def parni_brojevi(maks):
    for i in range(maks):
        if i % 2 == 0:
            yield i

for broj in parni_brojevi(10):
    print(broj)   # 0, 2, 4, 6, 8

Ovo se ponaša slično generator expressionu ((x for x in ... if uvjet)), ali kao punopravna funkcija može sadržavati složeniju logiku prije yield naredbe.
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - napredna kontrola toka',
      content: '''
Ova razina pokazala je kako se if/petlje ugrađuju duboko u strukturu Python jezika:

1. __iter__/__next__ omogućuju da VLASTITA klasa radi s for petljom
2. yield stvara generatore - jednostavniju alternativu punim iteratorima
3. while True + uvjetni break je standardni obrazac za interaktivne petlje
4. Generatori mogu uključivati uvjete za filtriranje vrijednosti

Ovo zaokružuje razumijevanje if/else i petlji na razini primjene i analize. Sljedeća razina (Bloom 5-6) fokusira se na pisanje kompletnih algoritama koji kombiniraju sve naučeno.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib34s4q1',
      type: QuestionType.matching,
      prompt: 'Upari metodu/koncept s njegovom ulogom.',
      matchPairs: {
        '__iter__': 'Vraća objekt koji se može iterirati (obično self)',
        '__next__': 'Vraća sljedeću vrijednost ili baca StopIteration',
        'yield': 'Pauzira funkciju i vraća vrijednost, pamti gdje je stala',
        'while True + break': 'Petlja koja se zaustavlja samo eksplicitnim izlazom',
      },
    ),
    Question(
      id: 'ib34s4q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake izvršavanja for broj in Brojac(3) - konceptualno.',
      hierarchyItems: [
        'Python poziva __iter__ da dobije iterator objekt',
        'Python poziva __next__ za prvu vrijednost (1)',
        'Python nastavlja pozivati __next__ (2, pa 3)',
        'Kad __next__ baci StopIteration, petlja završava',
      ],
    ),
    Question(
      id: 'ib34s4q3',
      type: QuestionType.matching,
      prompt: 'Upari pristup s onim što opisuje.',
      matchPairs: {
        'Klasa s __iter__/__next__': 'Puni, eksplicitni način pravljenja iteratora',
        'Generatorska funkcija s yield': 'Jednostavnija alternativa istoj funkcionalnosti',
        'Generator s uvjetom prije yield': 'Filtrira koje vrijednosti se "isporučuju"',
        'while True u glavnom izborniku': 'Petlja koja traje dok korisnik ne odabere izlaz',
      },
    ),
  ],
);

final Lesson ifelseBloom34 = Lesson(
  id: 302,
  title: 'If/else - Strukture podataka i OOP',
  bloomLevels: '3-4',
  questionType: QuestionType.matching,
  sections: [ifB34S1, ifB34S2, ifB34S3, ifB34S4],
);