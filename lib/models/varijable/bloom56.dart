// lib/models/varijable/bloom56.dart
//
// Tema VARIJABLE — Bloom 5-6 (Evaluacija/Kreiranje)
// Pisanje kompletnih programa koji koriste varijable na napredan način.
// Pitanja: pisanje/izvršavanje koda.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Napredne petlje s varijablama
// ---------------------------------------------------------------------

final LessonSection varB56S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Ugniježđene petlje i varijable brojača',
      content: '''
Petlja može sadržavati drugu petlju unutar sebe, s vlastitim varijablama brojača:

for i in range(3):
    for j in range(3):
        print(f"({i}, {j})")

Svaka petlja ima svoju NEZAVISNU varijablu (i, j) - vanjska petlja se izvrši jednom po vrijednosti i, a za svaku tu vrijednost, unutarnja petlja prođe kroz sve svoje vrijednosti j.

Ovo je osnova za rad s matricama:

matrica = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
for red in matrica:
    for element in red:
        print(element, end=" ")
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'List comprehension - napredniji primjeri',
      content: '''
List comprehension može uključivati i ugniježđene petlje i uvjete:

parovi = [(i, j) for i in range(3) for j in range(3) if i != j]

matrica = [[1, 2], [3, 4], [5, 6]]
ravna = [broj for red in matrica for broj in red]
# [1, 2, 3, 4, 5, 6]

kvadrati = [[x**2 for x in red] for red in matrica]

Redoslijed for petlji u comprehension-u odgovara redoslijedu ugniježđenih for petlji u "klasičnoj" verziji.
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Zip - iteracija kroz više varijabli odjednom',
      content: '''
zip() spaja više kolekcija, omogućujući iteraciju kroz njih ISTOVREMENO:

imena = ["Ana", "Marko", "Ivana"]
ocjene = [5, 4, 5]

for ime, ocjena in zip(imena, ocjene):
    print(f"{ime}: {ocjena}")

Ako liste nisu iste duljine, zip() staje na kraju KRAĆE liste. zip() vraća iterator, pa ga za ispis kao listu treba pretvoriti: list(zip(imena, ocjene)).
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Ugrađene funkcije umjesto ručnih petlji',
      content: '''
Python nudi ugrađene funkcije koje su često brže i čitljivije od ručno pisane petlje:

suma = sum(brojevi)
najveci = max(brojevi)
ima_negativnih = any(x < 0 for x in brojevi)
svi_pozitivni = all(x > 0 for x in brojevi)

Ugrađene funkcije su implementirane u C-u "ispod haube", pa su brže od ekvivalentne Python petlje - koristi ih kad god je moguće umjesto ručnog pisanja petlje s pomoćnim varijablama.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Generatori - memorijski efikasna alternativa',
      content: '''
Kad radiš s VELIKIM količinama podataka, generator izračunava vrijednosti "u hodu" umjesto da odmah stvori cijelu listu u memoriji:

kvadrati_lista = [x**2 for x in range(1000000)]   # odmah zauzima memoriju za milijun brojeva
kvadrati_gen = (x**2 for x in range(1000000))      # vrijednosti se stvaraju jedna po jedna

Sintaksa je gotovo identična, ali generator ne zauzima memoriju za sve elemente odjednom - koristan kad radiš s ogromnim skupovima podataka.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb56s1q1',
      type: QuestionType.code,
      prompt: 'Napiši kod koji pomoću ugniježđenih for petlji ispisuje tablicu množenja za brojeve od 1 do 3.',
      codeTaskPrompt: 'for i in range(1, 4):\n    for j in range(1, 4):\n        print(i * j)',
      expectedOutput: '1\n2\n3\n2\n4\n6\n3\n6\n9',
    ),
    Question(
      id: 'vb56s1q2',
      type: QuestionType.code,
      prompt: 'Napiši list comprehension koji od matrice [[1,2],[3,4],[5,6]] napravi ravnu listu svih brojeva.',
      codeTaskPrompt: 'matrica = [[1,2],[3,4],[5,6]]\nravna = [broj for red in matrica for broj in red]\nprint(ravna)',
      expectedOutput: '[1, 2, 3, 4, 5, 6]',
    ),
    Question(
      id: 'vb56s1q3',
      type: QuestionType.code,
      prompt: 'Koristeći zip(), napiši petlju koja ispisuje "ime: ocjena" za imena=["Ana","Marko"] i ocjene=[5,4].',
      codeTaskPrompt: 'imena = ["Ana", "Marko"]\nocjene = [5, 4]\nfor ime, ocjena in zip(imena, ocjene):\n    print(f"{ime}: {ocjena}")',
      expectedOutput: 'Ana: 5\nMarko: 4',
    ),
    Question(
      id: 'vb56s1q4',
      type: QuestionType.code,
      prompt: 'Napiši kod koji pomoću sum() i len() izračuna prosjek liste ocjene = [5, 4, 5, 3].',
      codeTaskPrompt: 'ocjene = [5, 4, 5, 3]\nprosjek = sum(ocjene) / len(ocjene)\nprint(prosjek)',
      expectedOutput: '4.25',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Rekurzija
// ---------------------------------------------------------------------

final LessonSection varB56S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Što je rekurzija?',
      content: '''
Rekurzivna funkcija poziva SAMU SEBE, obično s manjim/jednostavnijim ulaznim podatkom, dok ne dosegne bazni slučaj:

def faktorijel(n):
    if n <= 1:              # bazni slučaj
        return 1
    return n * faktorijel(n - 1)   # rekurzivni poziv

print(faktorijel(5))   # 120

Svaki rekurzivni poziv sprema SVOJU VLASTITU vrijednost varijable n na tzv. call stack (stog poziva) u memoriji - dok se ne dosegne bazni slučaj, pozivi se gomilaju, a zatim se rezultati vraćaju natrag.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Bazni slučaj - zašto je obavezan',
      content: '''
Bez baznog slučaja, rekurzivna funkcija bi se pozivala BESKONAČNO, sve dok Python ne baci RecursionError:

def bez_baze(n):
    return n * bez_baze(n - 1)   # nema uvjeta za zaustavljanje!

Svaka ispravna rekurzivna funkcija mora imati:
1. Bazni slučaj - uvjet koji vraća vrijednost BEZ daljnjeg rekurzivnog poziva
2. Rekurzivni korak - poziva samu sebe s podatkom koji se PRIBLIŽAVA baznom slučaju
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Rekurzija vs petlja',
      content: '''
Svaki problem rješiv rekurzijom rješiv je i petljom:

# Rekurzivno
def faktorijel(n):
    if n <= 1:
        return 1
    return n * faktorijel(n - 1)

# Iterativno
def faktorijel(n):
    rezultat = 1
    for i in range(1, n + 1):
        rezultat *= i
    return rezultat

Rekurzija je elegantnija za prirodno rekurzivne probleme, ali troši više memorije (call stack) i može biti sporija.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Fibonacci - klasičan primjer',
      content: '''
Fibonaccijev niz - svaki broj je zbroj prethodna dva:

def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(6))   # 8

Ovaj primjer ima DVA rekurzivna poziva - stog poziva "grana" se u dva smjera, što čini ovu implementaciju eksponencijalno sporom za veće n.
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Rekurzija nad ugniježđenim varijablama',
      content: '''
Rekurzija je prirodna za obilazak struktura koje su same po sebi ugniježđene:

def zbroji_sve(podaci):
    ukupno = 0
    for element in podaci:
        if isinstance(element, list):
            ukupno += zbroji_sve(element)
        else:
            ukupno += element
    return ukupno

print(zbroji_sve([1, [2, 3], [4, [5, 6]]]))   # 21

Kad element NIJE lista, funkcija ga jednostavno zbraja bez daljnjeg rekurzivnog poziva.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb56s2q1',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju faktorijel(n) koja računa n! i ispiši faktorijel(6).',
      codeTaskPrompt: 'def faktorijel(n):\n    if n <= 1:\n        return 1\n    return n * faktorijel(n - 1)\n\nprint(faktorijel(6))',
      expectedOutput: '720',
    ),
    Question(
      id: 'vb56s2q2',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju fibonacci(n) i ispiši fibonacci(7).',
      codeTaskPrompt: 'def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n - 1) + fibonacci(n - 2)\n\nprint(fibonacci(7))',
      expectedOutput: '13',
    ),
    Question(
      id: 'vb56s2q3',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju suma_do(n) koja rekurzivno zbraja brojeve od 1 do n, i ispiši suma_do(5).',
      codeTaskPrompt: 'def suma_do(n):\n    if n <= 1:\n        return n\n    return n + suma_do(n - 1)\n\nprint(suma_do(5))',
      expectedOutput: '15',
    ),
    Question(
      id: 'vb56s2q4',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju koja obrće string, i ispiši rezultat za "Split".',
      codeTaskPrompt: 'def obrni(s):\n    if len(s) <= 1:\n        return s\n    return obrni(s[1:]) + s[0]\n\nprint(obrni("Split"))',
      expectedOutput: 'tilpS',
    ),
    Question(
      id: 'vb56s2q5',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju zbroji_sve() koja zbraja sve brojeve u ugniježđenoj listi [1, [2, 3], [4, [5, 6]]].',
      codeTaskPrompt: 'def zbroji_sve(podaci):\n    ukupno = 0\n    for element in podaci:\n        if isinstance(element, list):\n            ukupno += zbroji_sve(element)\n        else:\n            ukupno += element\n    return ukupno\n\nprint(zbroji_sve([1, [2, 3], [4, [5, 6]]]))',
      expectedOutput: '21',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Rad s datotekama
// ---------------------------------------------------------------------

final LessonSection varB56S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Otvaranje i čitanje datoteke',
      content: '''
Python čita/piše datoteke pomoću open(). Preporučeni način koristi with, koji automatski zatvara datoteku kad blok koda završi:

with open("podaci.txt", "r") as f:
    sadrzaj = f.read()
    print(sadrzaj)

Način rada određuje što se smije raditi s datotekom: "r" (čitanje), "w" (pisanje, briše postojeći sadržaj), "a" (append/dodavanje), "r+" (čitanje i pisanje).

Napomena: ako datoteka ne postoji, otvaranje u modu "r" javlja pogrešku, pa se u primjerima koji slijede datoteka najprije stvara pisanjem, a tek se zatim čita.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Čitanje po linijama',
      content: '''
Za veće datoteke, bolje je čitati liniju po liniju (štedi memoriju):

with open("podaci.txt", "r") as f:
    for linija in f:
        print(linija.strip())

Alternativno, readlines() vraća listu svih linija odjednom u memoriju - za jako velike datoteke, iteracija linija po linija je memorijski efikasnija.

strip() uklanja razmake i prijelom retka s kraja pročitane linije, pa se ispis ne razdvaja dodatnim praznim redcima.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Pisanje u datoteku',
      content: '''
Pisanje radi analogno čitanju:

with open("rezultati.txt", "w") as f:
    f.write("Prvi red\\n")
    f.write("Drugi red\\n")

Ako datoteku otvoriš ponovno s "w", PREPISAT ĆE cijeli prethodni sadržaj. Za dodavanje bez brisanja postojećeg, koristi "a".

Čest obrazac je stvoriti datoteku, dopuniti je i zatim pročitati njezin sadržaj:

with open("dat.txt", "w") as f:
    f.write("Prvi sadrzaj\\n")

with open("dat.txt", "a") as f:
    f.write("Dodano na kraj\\n")

with open("dat.txt", "r") as f:
    print(f.read().strip())
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Rad s CSV datotekama',
      content: '''
CSV je čest format za tablične podatke. Python ima ugrađeni modul csv:

import csv

with open("studenti.csv", "r") as f:
    citac = csv.reader(f)
    for red in citac:
        print(red)   # svaki red je lista varijabli (stringova)

Modul csv automatski rješava specifičnosti formata, što bi ručno parsiranje teksta činilo kompliciranijim.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Provjera postojanja datoteke',
      content: '''
Prije rada s datotekom, korisno je provjeriti postoji li:

from pathlib import Path
putanja = Path("podaci.txt")
if putanja.exists():
    sadrzaj = putanja.read_text()

pathlib nudi objektno-orijentiran, čitljiviji način rada s putanjama datoteka, preporučen za novi kod umjesto starijeg os.path pristupa.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb56s3q1',
      type: QuestionType.code,
      prompt: 'Napiši kod koji u datoteku "test.txt" upiše tekst "Pozdrav iz Pythona", zatim je pročita i ispiše njezin sadržaj.',
      codeTaskPrompt: 'with open("test.txt", "w") as f:\n    f.write("Pozdrav iz Pythona")\n\nwith open("test.txt", "r") as f:\n    print(f.read())',
      expectedOutput: 'Pozdrav iz Pythona',
    ),
    Question(
      id: 'vb56s3q2',
      type: QuestionType.code,
      prompt: 'Napiši kod koji u datoteku "test.txt" upiše dva retka, zatim je pročita liniju po liniju i ispiše svaku bez praznina na kraju.',
      codeTaskPrompt: 'with open("test.txt", "w") as f:\n    f.write("prvi redak\\ndrugi redak\\n")\n\nwith open("test.txt", "r") as f:\n    for linija in f:\n        print(linija.strip())',
      expectedOutput: 'prvi redak\ndrugi redak',
    ),
    Question(
      id: 'vb56s3q3',
      type: QuestionType.code,
      prompt: 'Pokaži razliku između "w" i "a" moda: u modu "w" upiši redak "Prvi sadrzaj", u modu "a" dodaj "Dodano na kraj", zatim ispiši sadržaj datoteke.',
      codeTaskPrompt: 'with open("dat.txt", "w") as f:\n    f.write("Prvi sadrzaj\\n")\n\nwith open("dat.txt", "a") as f:\n    f.write("Dodano na kraj\\n")\n\nwith open("dat.txt", "r") as f:\n    print(f.read().strip())',
      expectedOutput: 'Prvi sadrzaj\nDodano na kraj',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Obrada grešaka i moduli
// ---------------------------------------------------------------------

final LessonSection varB56S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'try / except - hvatanje grešaka',
      content: '''
try/except omogućuje da program "uhvati" grešku i nastavi raditi:

try:
    broj = int(input("Unesi broj: "))
    rezultat = 10 / broj
except ValueError:
    print("To nije valjan broj")
except ZeroDivisionError:
    print("Ne možeš dijeliti s nulom")

Python prvo pokušava izvršiti try blok. Ako se dogodi greška, traži odgovarajući except blok prema tipu greške.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'finally i višestruko hvatanje grešaka',
      content: '''
finally blok se izvršava UVIJEK, bilo da se greška dogodila ili ne:

try:
    f = open("podaci.txt")
except FileNotFoundError:
    print("Datoteka ne postoji")
finally:
    print("Ovo se uvijek izvršava")

Više tipova grešaka može se hvatati u istom except-u pomoću tuple-a: except (ValueError, TypeError):
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Podizanje vlastitih grešaka (raise)',
      content: '''
Možeš i sam podići grešku kad tvoja varijabla/funkcija dobije neispravnu vrijednost:

def postavi_dob(dob):
    if dob < 0:
        raise ValueError("Dob ne može biti negativna")
    return dob

try:
    postavi_dob(-5)
except ValueError as e:
    print(f"Greška: {e}")

as e omogućuje dohvaćanje poruke greške u varijablu.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Moduli i import',
      content: '''
Modul je datoteka s kodom koju možeš ponovno koristiti pomoću import:

import moj_modul
print(moj_modul.pozdravi("Ana"))

from moj_modul import pozdravi
print(pozdravi("Ana"))

Python dolazi s mnogo ugrađenih modula (math, random, datetime, os, csv) koje ne trebaš instalirati.

Primjer korištenja ugrađenog modula math:

import math
print(math.sqrt(16))   # 4.0

sqrt() računa drugi korijen broja. Modul math sadrži i druge korisne funkcije, npr. math.pi, math.pow() i math.floor().
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - pun krug varijable',
      content: '''
Kroz sve tri Bloom razine ove teme, pratila si varijablu od najosnovnijeg pojma do pisanja punih programa:

Bloom 1-2: pojedinačna varijabla, tip, memorija
Bloom 3-4: organizacija varijabli u rječnike, klase, funkcije
Bloom 5-6: pisanje programa koji koriste varijable u petljama, rekurziji, radu s datotekama i sigurnoj obradi grešaka

Ovo zaokružuje temu Varijable. Isti obrazac (osnove -> strukture -> pisanje koda) primjenjuje se i na teme Liste i If/else.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb56s4q1',
      type: QuestionType.code,
      prompt: 'Napiši kod koji pokušava podijeliti 10 s 0, uhvati ZeroDivisionError i ispiše "Ne može se dijeliti s nulom".',
      codeTaskPrompt: 'try:\n    rezultat = 10 / 0\nexcept ZeroDivisionError:\n    print("Ne može se dijeliti s nulom")',
      expectedOutput: 'Ne može se dijeliti s nulom',
    ),
    Question(
      id: 'vb56s4q2',
      type: QuestionType.code,
      prompt: 'Napiši funkciju postavi_dob(dob) koja podiže ValueError za dob < 0, i pozovi je s -5 unutar try/except.',
      codeTaskPrompt: 'def postavi_dob(dob):\n    if dob < 0:\n        raise ValueError("Dob ne može biti negativna")\n    return dob\n\ntry:\n    postavi_dob(-5)\nexcept ValueError as e:\n    print(e)',
      expectedOutput: 'Dob ne može biti negativna',
    ),
    Question(
      id: 'vb56s4q3',
      type: QuestionType.code,
      prompt: 'Napiši try/except/finally blok koji pretvara "abc" u int, hvata ValueError, i u finally ispiše "Gotovo".',
      codeTaskPrompt: 'try:\n    broj = int("abc")\nexcept ValueError:\n    print("Nije valjan broj")\nfinally:\n    print("Gotovo")',
      expectedOutput: 'Nije valjan broj\nGotovo',
    ),
    Question(
      id: 'vb56s4q4',
      type: QuestionType.code,
      prompt: 'Napiši funkciju kvadrat(x) koja vraća x na kvadrat, s try/except koji hvata TypeError ako x nije broj.',
      codeTaskPrompt: 'def kvadrat(x):\n    try:\n        return x ** 2\n    except TypeError:\n        return "x mora biti broj"\n\nprint(kvadrat(5))\nprint(kvadrat("a"))',
      expectedOutput: '25\nx mora biti broj',
    ),
    Question(
      id: 'vb56s4q5',
      type: QuestionType.code,
      prompt: 'Napiši kod koji hvata i ValueError i ZeroDivisionError u jednom except bloku, za izraz 10 / int("0").',
      codeTaskPrompt: 'try:\n    rezultat = 10 / int("0")\nexcept (ValueError, ZeroDivisionError) as e:\n    print(f"Greška: {type(e).__name__}")',
      expectedOutput: 'Greška: ZeroDivisionError',
    ),
    Question(
      id: 'vb56s4q6',
      type: QuestionType.code,
      prompt: 'Napiši kod koji uvozi modul math i ispisuje korijen broja 16.',
      codeTaskPrompt: 'import math\nprint(math.sqrt(16))',
      expectedOutput: '4.0',
    ),
  ],
);

final Lesson varijableBloom56 = Lesson(
  id: 103,
  title: 'Varijable - Pisanje i izvršavanje koda',
  bloomLevels: '5-6',
  questionType: QuestionType.code,
  sections: [varB56S1, varB56S2, varB56S3, varB56S4],
);