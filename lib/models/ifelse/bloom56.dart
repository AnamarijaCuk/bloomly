// lib/models/ifelse/bloom56.dart
//
// Tema IF/ELSE — Bloom 5-6 (Evaluacija/Kreiranje)
// Pisanje kompletnih algoritama. Pitanja: pisanje/izvršavanje koda.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Klasični algoritamski zadaci
// ---------------------------------------------------------------------

final LessonSection ifB56S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'FizzBuzz - potpuna implementacija',
      content: '''
FizzBuzz kombinira petlju i više uvjeta - klasičan test osnovnog algoritamskog razmišljanja:

for i in range(1, 21):
    if i % 3 == 0 and i % 5 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)

Redoslijed provjere (oba uvjeta prvo) je ključan - inače bi se broj 15 pogrešno ispisao kao samo "Fizz" ili samo "Buzz".
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Provjera je li broj prost - optimizirano',
      content: '''
Osnovna verzija provjere prostog broja prolazi kroz SVE brojeve do n. Optimizirana verzija provjerava samo do kvadratnog korijena:

def je_prost(n):
    if n < 2:
        return False
    i = 2
    while i * i <= n:
        if n % i == 0:
            return False
        i += 1
    return True

print(je_prost(97))    # True
print(je_prost(100))   # False

Uvjet i * i <= n je matematički ekvivalentan i <= sqrt(n) - ako broj n ima djelitelj VEĆI od svog korijena, mora imati i djelitelj MANJI, pa je dovoljno provjeriti samo do korijena.
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Rešeto Eratostenovo - pronalaženje svih prostih brojeva',
      content: '''
Za pronalazak SVIH prostih brojeva do N, efikasniji je algoritam koji "označava" složene brojeve umjesto provjere svakog pojedinačno:

def resetoEratostena(n):
    prosti = [True] * (n + 1)
    prosti[0] = prosti[1] = False
    for i in range(2, int(n**0.5) + 1):
        if prosti[i]:
            for visekratnik in range(i*i, n + 1, i):
                prosti[visekratnik] = False
    return [i for i in range(n + 1) if prosti[i]]

print(resetoEratostena(30))
# [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

Ovaj algoritam kombinira listu bool vrijednosti, ugniježđene petlje i uvjete - puno brži od provjere svakog broja pojedinačno funkcijom je_prost().
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Provjera je li broj palindrom',
      content: '''
Palindrom je broj (ili string) koji se čita isto s obje strane:

def je_palindrom(broj):
    tekst = str(broj)
    return tekst == tekst[::-1]

print(je_palindrom(12321))   # True
print(je_palindrom(12345))   # False

Alternativna implementacija bez slicinga, ručno kroz petlju:

def je_palindrom_petljom(broj):
    tekst = str(broj)
    lijevo, desno = 0, len(tekst) - 1
    while lijevo < desno:
        if tekst[lijevo] != tekst[desno]:
            return False
        lijevo += 1
        desno -= 1
    return True
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Collatzov niz',
      content: '''
Collatzova nagađanje: za bilo koji pozitivan broj, ako je paran podijeli ga s 2, ako je neparan pomnoži s 3 i dodaj 1 - ponavljaj dok ne dosegneš 1:

def collatz(n):
    koraci = [n]
    while n != 1:
        if n % 2 == 0:
            n = n // 2
        else:
            n = 3 * n + 1
        koraci.append(n)
    return koraci

print(collatz(6))   # [6, 3, 10, 5, 16, 8, 4, 2, 1]

Ovaj primjer kombinira while petlju (nepoznat broj koraka unaprijed) s if/else unutar nje - do danas nije matematički dokazano da niz UVIJEK završi na 1 za svaki početni broj.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib56s1q1',
      type: QuestionType.code,
      prompt: 'Napiši FizzBuzz kod za brojeve od 1 do 20 i pokaži samo prvih 5 ispisa (1-5).',
      codeTaskPrompt: 'for i in range(1, 6):\n    if i % 3 == 0 and i % 5 == 0:\n        print("FizzBuzz")\n    elif i % 3 == 0:\n        print("Fizz")\n    elif i % 5 == 0:\n        print("Buzz")\n    else:\n        print(i)',
      expectedOutput: '1\n2\nFizz\n4\nBuzz',
    ),
    Question(
      id: 'ib56s1q2',
      type: QuestionType.code,
      prompt: 'Napiši optimiziranu je_prost(n) funkciju (provjera do korijena) i pozovi je za n=97.',
      codeTaskPrompt: 'def je_prost(n):\n    if n < 2:\n        return False\n    i = 2\n    while i * i <= n:\n        if n % i == 0:\n            return False\n        i += 1\n    return True\n\nprint(je_prost(97))',
      expectedOutput: 'True',
    ),
    Question(
      id: 'ib56s1q3',
      type: QuestionType.code,
      prompt: 'Napiši funkciju je_palindrom(broj) i provjeri je li 12321 palindrom.',
      codeTaskPrompt: 'def je_palindrom(broj):\n    tekst = str(broj)\n    return tekst == tekst[::-1]\n\nprint(je_palindrom(12321))',
      expectedOutput: 'True',
    ),
    Question(
      id: 'ib56s1q4',
      type: QuestionType.code,
      prompt: 'Napiši funkciju collatz(n) koja vraća Collatzov niz za n=6.',
      codeTaskPrompt: 'def collatz(n):\n    koraci = [n]\n    while n != 1:\n        if n % 2 == 0:\n            n = n // 2\n        else:\n            n = 3 * n + 1\n        koraci.append(n)\n    return koraci\n\nprint(collatz(6))',
      expectedOutput: '[6, 3, 10, 5, 16, 8, 4, 2, 1]',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Simulacije i igre
// ---------------------------------------------------------------------

final LessonSection ifB56S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Simulacija bacanja kockice do određenog broja',
      content: '''
Kombinacija while petlje, uvjeta i slučajnih brojeva za jednostavnu simulaciju:

import random

def baci_dok_ne_dobijes_sest():
    brojac_bacanja = 0
    while True:
        brojac_bacanja += 1
        broj = random.randint(1, 6)
        if broj == 6:
            break
    return brojac_bacanja

print(baci_dok_ne_dobijes_sest())   # različit rezultat svaki put

while True + uvjetni break je standardan obrazac kad ne znaš unaprijed koliko će iteracija trebati - ovdje čekamo "slučajni" događaj.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Igra pogađanja broja',
      content: '''
Klasična igra koja kombinira petlju, uvjete i brojanje pokušaja:

import random

def igra_pogadjanja(tajni_broj, max_pokusaja=5):
    for pokusaj in range(1, max_pokusaja + 1):
        nagadanje = random.randint(1, 100)   # simulacija "igrača"
        if nagadanje == tajni_broj:
            return f"Pogodio na {pokusaj}. pokušaju!"
        elif nagadanje < tajni_broj:
            print(f"Pokušaj {pokusaj}: {nagadanje} je premalo")
        else:
            print(f"Pokušaj {pokusaj}: {nagadanje} je preveliko")
    return "Nisi pogodio u zadanom broju pokušaja"

print(igra_pogadjanja(42))

Ova struktura (for petlja s limitiranim brojem pokušaja + if/elif za povratnu informaciju) čest je obrazac za implementaciju kviz/igra logike - relevantno za tvoju Bloomly aplikaciju.
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Simulacija sustava života (Conway\'s Game of Life - pojednostavljeno)',
      content: '''
Pojednostavljena verzija poznate simulacije: jedna ćelija na 1D redu, koja "živi" ili "umire" prema broju susjeda:

def sljedeca_generacija(red):
    nova = []
    n = len(red)
    for i in range(n):
        lijevi = red[i-1] if i > 0 else 0
        desni = red[i+1] if i < n-1 else 0
        susjedi = lijevi + desni
        if red[i] == 1 and susjedi == 1:
            nova.append(1)   # preživljava
        elif red[i] == 0 and susjedi == 2:
            nova.append(1)   # rađa se
        else:
            nova.append(0)   # umire ili ostaje mrtva
    return nova

pocetno = [0, 1, 1, 0, 0]
print(sljedeca_generacija(pocetno))

Ovaj primjer pokazuje kako se if/elif uvjeti kombiniraju s indeksiranjem liste (uz provjeru granica) za simulaciju "susjedstva" - temeljni koncept u simulacijama i celularnim automatima.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Jednostavan sustav bodovanja kviza',
      content: '''
Kombinacija petlje kroz pitanja, uvjeta za provjeru odgovora, i akumulacije bodova:

def ocijeni_kviz(odgovori_korisnika, tocni_odgovori):
    bodovi = 0
    for korisnikov, tocan in zip(odgovori_korisnika, tocni_odgovori):
        if korisnikov == tocan:
            bodovi += 1

    postotak = (bodovi / len(tocni_odgovori)) * 100

    if postotak >= 80:
        ocjena = "Odlično"
    elif postotak >= 60:
        ocjena = "Dobro"
    elif postotak >= 40:
        ocjena = "Dovoljno"
    else:
        ocjena = "Nedovoljno"

    return bodovi, ocjena

odgovori = ["a", "c", "b"]
tocni = ["a", "b", "b"]
print(ocijeni_kviz(odgovori, tocni))   # (2, 'Dobro')

Ovaj obrazac direktno odgovara logici koju bi trebala implementirati u Bloomly za ocjenjivanje kvizova nakon svake sekcije lekcije.
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Rekapitulacija - simulacije kao kombinacija svega naučenog',
      content: '''
Ova sekcija pokazala je kako se if/else i petlje kombiniraju za simulacije i igre:

1. while True + uvjetni break simulira "čekanje" na slučajni događaj
2. for petlja s limitom pokušaja + if/elif implementira logiku igre
3. Indeksiranje s provjerom granica (uz if) omogućuje simulaciju "susjedstva"
4. Kombinacija petlje + zip + akumulacije + if/elif implementira sustav bodovanja

Ova posljednja tehnika (ocjenjivanje kviza) direktno je primjenjiva na logiku koju Bloomly treba implementirati za provjeru odgovora nakon svake sekcije.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib56s2q1',
      type: QuestionType.code,
      prompt: 'Napiši funkciju koja koristi while True i uvjet za simulaciju bacanja kockice dok ne padne 6 (koristi random.seed(1) za ponovljivost).',
      codeTaskPrompt: 'import random\nrandom.seed(1)\n\ndef baci_dok_ne_dobijes_sest():\n    brojac = 0\n    while True:\n        brojac += 1\n        broj = random.randint(1, 6)\n        if broj == 6:\n            break\n    return brojac\n\nprint(baci_dok_ne_dobijes_sest())',
      expectedOutput: '9',
    ),
    Question(
      id: 'ib56s2q2',
      type: QuestionType.code,
      prompt: 'Napiši funkciju ocijeni_kviz koja uspoređuje odgovore ["a","c","b"] s točnima ["a","b","b"] i vraća broj bodova i ocjenu.',
      codeTaskPrompt: 'def ocijeni_kviz(odgovori_korisnika, tocni_odgovori):\n    bodovi = 0\n    for korisnikov, tocan in zip(odgovori_korisnika, tocni_odgovori):\n        if korisnikov == tocan:\n            bodovi += 1\n    postotak = (bodovi / len(tocni_odgovori)) * 100\n    if postotak >= 80:\n        ocjena = "Odlično"\n    elif postotak >= 60:\n        ocjena = "Dobro"\n    elif postotak >= 40:\n        ocjena = "Dovoljno"\n    else:\n        ocjena = "Nedovoljno"\n    return bodovi, ocjena\n\nprint(ocijeni_kviz(["a","c","b"], ["a","b","b"]))',
      expectedOutput: "(2, 'Dobro')",
    ),
    Question(
      id: 'ib56s2q3',
      type: QuestionType.code,
      prompt: 'Napiši kod koji za listu ćelija [0,1,1,0,0] izračuna sljedeću generaciju prema pravilima Game of Life (pojednostavljeno, 1D).',
      codeTaskPrompt: 'def sljedeca_generacija(red):\n    nova = []\n    n = len(red)\n    for i in range(n):\n        lijevi = red[i-1] if i > 0 else 0\n        desni = red[i+1] if i < n-1 else 0\n        susjedi = lijevi + desni\n        if red[i] == 1 and susjedi == 1:\n            nova.append(1)\n        elif red[i] == 0 and susjedi == 2:\n            nova.append(1)\n        else:\n            nova.append(0)\n    return nova\n\nprint(sljedeca_generacija([0,1,1,0,0]))',
      expectedOutput: '[0, 1, 1, 0, 0]',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Rekurzija s uvjetima
// ---------------------------------------------------------------------

final LessonSection ifB56S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Rekurzivni FizzBuzz',
      content: '''
Iako je petlja prirodniji izbor za FizzBuzz, rekurzija je moguća i koristan primjer kombiniranja uvjeta i rekurzivnog poziva:

def fizzbuzz_rekurzivno(n, maks):
    if n > maks:
        return
    if n % 15 == 0:
        print("FizzBuzz")
    elif n % 3 == 0:
        print("Fizz")
    elif n % 5 == 0:
        print("Buzz")
    else:
        print(n)
    fizzbuzz_rekurzivno(n + 1, maks)

fizzbuzz_rekurzivno(1, 5)
# 1
# 2
# Fizz
# 4
# Buzz

Bazni slučaj (n > maks) zaustavlja rekurziju; svaki poziv obrađuje JEDAN broj, zatim poziva samog sebe za sljedeći.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Rekurzivna binarna pretraga s uvjetima grananja',
      content: '''
def pogodi_broj_rekurzivno(tajni, min_g, max_g):
    if min_g > max_g:
        return -1   # nema rješenja
    sredina = (min_g + max_g) // 2
    if sredina == tajni:
        return sredina
    elif sredina < tajni:
        return pogodi_broj_rekurzivno(tajni, sredina + 1, max_g)
    else:
        return pogodi_broj_rekurzivno(tajni, min_g, sredina - 1)

print(pogodi_broj_rekurzivno(42, 1, 100))   # 42

Ovo je isti princip kao binarna pretraga nad listom, ali primijenjen izravno na RASPON brojeva - svaki rekurzivni poziv prepolovi preostali prostor pretrage.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Rekurzivno rješavanje labirinta (pojednostavljeno)',
      content: '''
Klasičan primjer rekurzije s više uvjeta grananja - pronalazak puta kroz jednostavan labirint (2D matrica):

def moze_izaci(labirint, x, y):
    if x < 0 or y < 0 or x >= len(labirint) or y >= len(labirint[0]):
        return False   # izvan granica
    if labirint[x][y] == 1:
        return False   # zid
    if labirint[x][y] == 2:
        return True    # izlaz pronađen
    labirint[x][y] = -1   # označi kao posjećeno
    return (moze_izaci(labirint, x+1, y) or
            moze_izaci(labirint, x-1, y) or
            moze_izaci(labirint, x, y+1) or
            moze_izaci(labirint, x, y-1))

Ovaj obrazac (provjeri granice, provjeri prepreke, označi posjećeno, rekurzivno probaj sve smjerove) je temelj algoritama pretrage poput DFS-a (depth-first search).
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Rekurzivna implementacija Hanojskih tornjeva',
      content: '''
Klasičan rekurzivni problem: premjesti n diskova s jednog stupa na drugi, koristeći treći kao pomoćni, uz pravilo da veći disk nikad ne ide na manji:

def hanoj(n, izvor, cilj, pomocni):
    if n == 1:
        print(f"Premjesti disk 1 s {izvor} na {cilj}")
        return
    hanoj(n - 1, izvor, pomocni, cilj)
    print(f"Premjesti disk {n} s {izvor} na {cilj}")
    hanoj(n - 1, pomocni, cilj, izvor)

hanoj(3, "A", "C", "B")

Rješenje za n diskova zahtijeva 2^n - 1 poteza. Ovaj problem je gotovo nemoguće riješiti petljom na intuitivan način - rekurzija prirodno odgovara strukturi problema.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Rekapitulacija - rekurzija kao alternativni oblik grananja',
      content: '''
Ova sekcija pokazala je kako se if/else prirodno kombinira s rekurzijom:

1. Bazni slučaj u rekurziji je UVIJEK if uvjet koji zaustavlja daljnje pozive
2. Rekurzivno grananje (if/elif/else) određuje KOJI rekurzivni poziv se izvršava
3. Rekurzija s VIŠE poziva (kao u rješavanju labirinta) istražuje više mogućih putova
4. Neki problemi (Hanojski tornjevi) prirodno odgovaraju rekurzivnoj strukturi

Ovime zaokružujemo vezu između if/else, petlji i rekurzije kao alternativnih, ali usko povezanih načina kontrole toka programa.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib56s3q1',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju fizzbuzz_rekurzivno(n, maks) i pozovi je za n=1, maks=5.',
      codeTaskPrompt: 'def fizzbuzz_rekurzivno(n, maks):\n    if n > maks:\n        return\n    if n % 15 == 0:\n        print("FizzBuzz")\n    elif n % 3 == 0:\n        print("Fizz")\n    elif n % 5 == 0:\n        print("Buzz")\n    else:\n        print(n)\n    fizzbuzz_rekurzivno(n + 1, maks)\n\nfizzbuzz_rekurzivno(1, 5)',
      expectedOutput: '1\n2\nFizz\n4\nBuzz',
    ),
    Question(
      id: 'ib56s3q2',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju pogodi_broj_rekurzivno koja pronalazi broj 42 u rasponu 1-100.',
      codeTaskPrompt: 'def pogodi_broj_rekurzivno(tajni, min_g, max_g):\n    if min_g > max_g:\n        return -1\n    sredina = (min_g + max_g) // 2\n    if sredina == tajni:\n        return sredina\n    elif sredina < tajni:\n        return pogodi_broj_rekurzivno(tajni, sredina + 1, max_g)\n    else:\n        return pogodi_broj_rekurzivno(tajni, min_g, sredina - 1)\n\nprint(pogodi_broj_rekurzivno(42, 1, 100))',
      expectedOutput: '42',
    ),
    Question(
      id: 'ib56s3q3',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju hanoj(n, izvor, cilj, pomocni) i pozovi je za n=2, "A", "C", "B".',
      codeTaskPrompt: 'def hanoj(n, izvor, cilj, pomocni):\n    if n == 1:\n        print(f"Premjesti disk 1 s {izvor} na {cilj}")\n        return\n    hanoj(n - 1, izvor, pomocni, cilj)\n    print(f"Premjesti disk {n} s {izvor} na {cilj}")\n    hanoj(n - 1, pomocni, cilj, izvor)\n\nhanoj(2, "A", "C", "B")',
      expectedOutput: 'Premjesti disk 1 s A na B\nPremjesti disk 2 s A na C\nPremjesti disk 1 s B na C',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Napredni projekti - spajanje svega
// ---------------------------------------------------------------------

final LessonSection ifB56S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Validator lozinke - kombinacija više uvjeta',
      content: '''
Praktičan primjer koji kombinira petlju, više uvjeta i zastavice (flag varijable):

def validiraj_lozinku(lozinka):
    ima_veliko = False
    ima_broj = False
    for znak in lozinka:
        if znak.isupper():
            ima_veliko = True
        if znak.isdigit():
            ima_broj = True

    if len(lozinka) < 8:
        return "Lozinka mora imati barem 8 znakova"
    if not ima_veliko:
        return "Lozinka mora sadržavati veliko slovo"
    if not ima_broj:
        return "Lozinka mora sadržavati broj"
    return "Lozinka je valjana"

print(validiraj_lozinku("Split123"))   # Lozinka je valjana
print(validiraj_lozinku("split"))       # Lozinka mora imati barem 8 znakova

Ovaj obrazac (petlja koja postavlja zastavice, zatim niz if provjera nakon petlje) čest je kod validacije korisničkog unosa u stvarnim aplikacijama.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Jednostavan kalkulator s obradom grešaka',
      content: '''
def kalkulator(a, operacija, b):
    if operacija == "+":
        return a + b
    elif operacija == "-":
        return a - b
    elif operacija == "*":
        return a * b
    elif operacija == "/":
        if b == 0:
            return "Greška: dijeljenje s nulom"
        return a / b
    else:
        return f"Nepoznata operacija: {operacija}"

print(kalkulator(10, "+", 5))    # 15
print(kalkulator(10, "/", 0))    # Greška: dijeljenje s nulom
print(kalkulator(10, "%", 5))    # Nepoznata operacija: %

Ovaj primjer kombinira if/elif grananje za odabir operacije, s ugniježđenim uvjetom za sigurnosnu provjeru dijeljenja s nulom.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Simulacija Bloomly kviza - potpuni primjer',
      content: '''
Kompletan primjer koji kombinira SVE naučeno u ovoj temi - petlju kroz pitanja, uvjete za ocjenjivanje, i odluku o vraćanju na raniju stranicu:

def obradi_sekciju_kviza(odgovori, tocni_odgovori, trenutna_stranica):
    tocno = 0
    for korisnikov, tocan in zip(odgovori, tocni_odgovori):
        if korisnikov == tocan:
            tocno += 1

    postotak_tocnih = tocno / len(tocni_odgovori)

    if postotak_tocnih == 1.0:
        return "nastavi_dalje", trenutna_stranica + 5
    elif postotak_tocnih >= 0.5:
        return "ponovi_djelomicno", trenutna_stranica - 2
    else:
        return "vrati_na_pocetak_sekcije", trenutna_stranica - 5

akcija, nova_stranica = obradi_sekciju_kviza(["a","b","c"], ["a","b","d"], 10)
print(akcija, nova_stranica)   # ponovi_djelomicno 8

Ovo je pojednostavljena verzija LOGIKE koju bi tvoja Bloomly aplikacija trebala implementirati (vjerojatno preko Gemini API-ja za pametnije odlučivanje, ali princip - if/elif na temelju postotka - ostaje isti).
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Testiranje granica - rubni slučajevi (edge cases)',
      content: '''
Dobar programer uvijek razmišlja o RUBNIM slučajevima - situacijama koje lako promaknu pri prvom pisanju koda:

def prosjek_liste(brojevi):
    if not brojevi:                    # rubni slučaj: prazna lista
        return None
    return sum(brojevi) / len(brojevi)

def prvi_element(lista):
    if len(lista) == 0:                # rubni slučaj: prazna lista
        return None
    return lista[0]

def podijeli(a, b):
    if b == 0:                          # rubni slučaj: dijeljenje s nulom
        return None
    return a / b

Svaka od ovih funkcija ima if uvjet koji SPECIFIČNO provjerava rubni slučaj PRIJE nego što se izvrši "normalna" logika - ovo sprječava rušenje programa na neočekivanim ulazima.
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - if/else i petlje kroz sve tri Bloom razine',
      content: '''
Ovim smo zaokružili temu If/else kroz sve tri razine:

Bloom 1-2 (Osnove): if/elif/else, for/while petlje, break/continue, osnovna akumulacija
Bloom 3-4 (Primjena/analiza): uvjeti unutar OOP metoda, konačni automati, iteratori i generatori
Bloom 5-6 (Evaluacija/kreiranje): algoritmi (rešeto, palindrom, Collatz), simulacije, rekurzija, validacija i rubni slučajevi

Kroz sve tri teme (Varijable, Liste, If/else) prošla si isti obrazac napretka - od "razumijem osnovni koncept" do "mogu pisati programe koji rješavaju stvarne probleme koristeći taj koncept". Ovo je upravo ono što Bloomly, kao aplikacija za učenje, treba mjeriti i poticati.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib56s4q1',
      type: QuestionType.code,
      prompt: 'Napiši funkciju validiraj_lozinku i testiraj je za "Split123".',
      codeTaskPrompt: 'def validiraj_lozinku(lozinka):\n    ima_veliko = False\n    ima_broj = False\n    for znak in lozinka:\n        if znak.isupper():\n            ima_veliko = True\n        if znak.isdigit():\n            ima_broj = True\n    if len(lozinka) < 8:\n        return "Lozinka mora imati barem 8 znakova"\n    if not ima_veliko:\n        return "Lozinka mora sadržavati veliko slovo"\n    if not ima_broj:\n        return "Lozinka mora sadržavati broj"\n    return "Lozinka je valjana"\n\nprint(validiraj_lozinku("Split123"))',
      expectedOutput: 'Lozinka je valjana',
    ),
    Question(
      id: 'ib56s4q2',
      type: QuestionType.code,
      prompt: 'Napiši funkciju kalkulator(a, operacija, b) i testiraj dijeljenje s nulom: kalkulator(10, "/", 0).',
      codeTaskPrompt: 'def kalkulator(a, operacija, b):\n    if operacija == "+":\n        return a + b\n    elif operacija == "-":\n        return a - b\n    elif operacija == "*":\n        return a * b\n    elif operacija == "/":\n        if b == 0:\n            return "Greška: dijeljenje s nulom"\n        return a / b\n    else:\n        return f"Nepoznata operacija: {operacija}"\n\nprint(kalkulator(10, "/", 0))',
      expectedOutput: 'Greška: dijeljenje s nulom',
    ),
    Question(
      id: 'ib56s4q3',
      type: QuestionType.code,
      prompt: 'Napiši funkciju obradi_sekciju_kviza koja odlučuje akciju na temelju postotka točnih odgovora, za odgovori=["a","b","c"], tocni=["a","b","d"], trenutna_stranica=10.',
      codeTaskPrompt: 'def obradi_sekciju_kviza(odgovori, tocni_odgovori, trenutna_stranica):\n    tocno = 0\n    for korisnikov, tocan in zip(odgovori, tocni_odgovori):\n        if korisnikov == tocan:\n            tocno += 1\n    postotak_tocnih = tocno / len(tocni_odgovori)\n    if postotak_tocnih == 1.0:\n        return "nastavi_dalje", trenutna_stranica + 5\n    elif postotak_tocnih >= 0.5:\n        return "ponovi_djelomicno", trenutna_stranica - 2\n    else:\n        return "vrati_na_pocetak_sekcije", trenutna_stranica - 5\n\nprint(obradi_sekciju_kviza(["a","b","c"], ["a","b","d"], 10))',
      expectedOutput: "('ponovi_djelomicno', 8)",
    ),
    Question(
      id: 'ib56s4q4',
      type: QuestionType.code,
      prompt: 'Napiši funkciju prosjek_liste koja vraća None za praznu listu, i testiraj je za praznu listu [].',
      codeTaskPrompt: 'def prosjek_liste(brojevi):\n    if not brojevi:\n        return None\n    return sum(brojevi) / len(brojevi)\n\nprint(prosjek_liste([]))',
      expectedOutput: 'None',
    ),
  ],
);

final Lesson ifelseBloom56 = Lesson(
  id: 303,
  title: 'If/else - Pisanje i izvršavanje koda',
  bloomLevels: '5-6',
  questionType: QuestionType.code,
  sections: [ifB56S1, ifB56S2, ifB56S3, ifB56S4],
);