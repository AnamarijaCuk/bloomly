// lib/models/liste/bloom34.dart
//
// Tema LISTE — Bloom 3-4 (Primjena/Analiza)
// Liste unutar struktura podataka i objekata. Uparivanje/hijerarhija.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Liste rječnika i liste objekata
// ---------------------------------------------------------------------

final LessonSection listB34S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Lista rječnika - modeliranje kolekcije zapisa',
      content: '''
Čest obrazac je lista rječnika - svaki rječnik predstavlja jedan "zapis" (npr. jednog studenta), a lista ih sve grupira:

studenti = [
    {"ime": "Ana", "ocjena": 5},
    {"ime": "Marko", "ocjena": 3},
    {"ime": "Ivana", "ocjena": 4},
]

print(studenti[0]["ime"])   # Ana

for student in studenti:
    print(f"{student['ime']}: {student['ocjena']}")

Ova struktura odgovara tablici u bazi podataka - svaki rječnik je "red", a ključevi rječnika su "stupci". Ovo je izuzetno čest obrazac kod rada s podacima iz API-ja ili baze (npr. Supabase vraća upravo listu rječnika).
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Sortiranje liste rječnika',
      content: '''
Sortiranje liste rječnika zahtijeva key parametar koji govori PO KOJEM ključu sortirati:

studenti = [
    {"ime": "Ana", "ocjena": 5},
    {"ime": "Marko", "ocjena": 3},
]

studenti.sort(key=lambda s: s["ocjena"])
# [{"ime": "Marko", "ocjena": 3}, {"ime": "Ana", "ocjena": 5}]

studenti.sort(key=lambda s: s["ocjena"], reverse=True)
# silazno, od najveće ocjene

lambda ovdje kaže Pythonu: "za svaki rječnik s u listi, uzmi vrijednost s['ocjena']  i po njoj usporedi elemente".
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Filtriranje i transformacija liste rječnika',
      content: '''
List comprehension nad listom rječnika omogućuje moćne transformacije u jednoj liniji:

studenti = [
    {"ime": "Ana", "ocjena": 5},
    {"ime": "Marko", "ocjena": 3},
]

samo_imena = [s["ime"] for s in studenti]
# ["Ana", "Marko"]

odlicni = [s["ime"] for s in studenti if s["ocjena"] == 5]
# ["Ana"]

Ovo je čest obrazac kod pripreme podataka za prikaz u UI-ju - imaš "sirove" podatke (listu rječnika) i izvlačiš samo ono što ti treba za prikaz.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Grupiranje elemenata liste',
      content: '''
Grupiranje elemenata liste prema nekom kriteriju čest je zadatak - npr. grupiranje studenata po ocjeni:

studenti = [
    {"ime": "Ana", "ocjena": 5},
    {"ime": "Marko", "ocjena": 3},
    {"ime": "Ivana", "ocjena": 5},
]

grupe = {}
for s in studenti:
    ocjena = s["ocjena"]
    if ocjena not in grupe:
        grupe[ocjena] = []
    grupe[ocjena].append(s["ime"])

# grupe = {5: ["Ana", "Ivana"], 3: ["Marko"]}

Rezultat je RJEČNIK čije su vrijednosti LISTE - kombinacija dviju struktura koje smo naučili u ovoj i prošloj temi.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Ugniježđene liste rječnika - složeni podaci',
      content: '''
Strukture se mogu ugnježđivati proizvoljno duboko - npr. lista studenata, gdje svaki student ima svoju listu ocjena:

studenti = [
    {"ime": "Ana", "ocjene": [5, 4, 5]},
    {"ime": "Marko", "ocjene": [3, 4, 3]},
]

for s in studenti:
    prosjek = sum(s["ocjene"]) / len(s["ocjene"])
    print(f"{s['ime']}: prosjek {prosjek:.2f}")

Ova struktura (lista rječnika, gdje rječnici sadrže liste) odgovara stvarnim podacima iz aplikacije poput Bloomly - npr. lista korisnika, gdje svaki korisnik ima listu svojih rezultata kvizova.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb34s1q1',
      type: QuestionType.matching,
      prompt: 'Upari pojam s njegovim opisom.',
      matchPairs: {
        'Lista rječnika': 'Kolekcija "zapisa", svaki zapis je jedan rječnik',
        'sort(key=lambda s: s["x"])': 'Sortira po vrijednosti ključa "x"',
        '[s["ime"] for s in lista]': 'Izvlači samo jedno polje iz svih zapisa',
        'Rječnik čije su vrijednosti liste': 'Rezultat grupiranja elemenata',
      },
    ),
    Question(
      id: 'lb34s1q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake grupiranja studenata po ocjeni u rječnik grupa.',
      hierarchyItems: [
        'Kreni od prazne liste rječnika grupa = {}',
        'Prođi kroz svaki zapis (student) u listi',
        'Provjeri postoji li već ključ za tu ocjenu u grupa',
        'Ako ne postoji, dodaj prazan popis za taj ključ',
        'Dodaj ime studenta u odgovarajuću listu',
      ],
    ),
    Question(
      id: 'lb34s1q3',
      type: QuestionType.matching,
      prompt: 'Upari izraz s rezultatom za studenti = [{"ime":"Ana","ocjena":5},{"ime":"Marko","ocjena":3}].',
      matchPairs: {
        'studenti[0]["ime"]': '"Ana"',
        '[s["ime"] for s in studenti]': '["Ana", "Marko"]',
        '[s for s in studenti if s["ocjena"]==5]': 'Lista koja sadrži samo Anin zapis',
        'len(studenti)': '2',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Liste kao atributi objekata
// ---------------------------------------------------------------------

final LessonSection listB34S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Lista kao atribut klase',
      content: '''
Objekti (instance klasa) često imaju listu kao jedan od svojih atributa:

class Razred:
    def __init__(self, naziv):
        self.naziv = naziv
        self.studenti = []   # lista koja pripada OVOM objektu

    def dodaj_studenta(self, ime):
        self.studenti.append(ime)

r = Razred("3A")
r.dodaj_studenta("Ana")
r.dodaj_studenta("Marko")
print(r.studenti)   # ["Ana", "Marko"]

Bitno: SVAKI objekt klase Razred dobiva SVOJU VLASTITU listu studenti (jer se stvara u __init__), a ne dijeljenu listu sa svim drugim instancama.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Uobičajena greška - mutable default argument',
      content: '''
Česta zamka početnika: postavljanje liste kao ZADANE (default) vrijednosti parametra funkcije:

def dodaj_stavku(stavka, lista=[]):   # OPASNO!
    lista.append(stavka)
    return lista

print(dodaj_stavku("a"))   # ["a"]
print(dodaj_stavku("b"))   # ["a", "b"] - NEOČEKIVANO! Ista lista se ponovno koristi!

Python stvara zadanu listu SAMO JEDNOM, kad se funkcija definira - ne pri svakom pozivu. Ispravno rješenje:

def dodaj_stavku(stavka, lista=None):
    if lista is None:
        lista = []
    lista.append(stavka)
    return lista
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Lista objekata (instanci klase)',
      content: '''
Lista može sadržavati objekte proizvoljne klase, ne samo osnovne tipove:

class Student:
    def __init__(self, ime, ocjena):
        self.ime = ime
        self.ocjena = ocjena

studenti = [Student("Ana", 5), Student("Marko", 3)]

for s in studenti:
    print(s.ime, s.ocjena)

Sortiranje liste objekata koristi key koji dohvaća atribut:

studenti.sort(key=lambda s: s.ocjena)

Ovo je uobičajen obrazac u stvarnim aplikacijama - npr. lista korisnika, gdje je svaki korisnik objekt klase User.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Metode koje vraćaju liste objekata',
      content: '''
Metode klase mogu obrađivati vlastitu listu i vraćati filtrirane/transformirane rezultate:

class Razred:
    def __init__(self):
        self.studenti = []

    def dodaj_studenta(self, student):
        self.studenti.append(student)

    def odlicni_studenti(self):
        return [s for s in self.studenti if s.ocjena == 5]

    def prosjek_razreda(self):
        if not self.studenti:
            return 0
        return sum(s.ocjena for s in self.studenti) / len(self.studenti)

Ovaj obrazac - klasa koja "posjeduje" listu i nudi metode za rad s njom - temelj je za organizaciju stvarnih aplikacija.
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Rekapitulacija - liste unutar objekata',
      content: '''
Ova sekcija pokazala je kako se liste koriste UNUTAR objektno orijentiranog koda:

1. Lista može biti atribut klase - svaki objekt ima svoju vlastitu listu
2. Nikad ne koristi mutable (listu) kao zadanu vrijednost parametra funkcije
3. Lista može sadržavati objekte proizvoljne klase, ne samo brojeve/stringove
4. Sortiranje/filtriranje liste objekata koristi lambda koja dohvaća atribut

Ova kombinacija (klasa + lista kao atribut + metode za rad s njom) je temelj za organizaciju stvarnih aplikacija - npr. u Bloomly, klasa Kviz mogla bi imati listu pitanja kao svoj atribut.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb34s2q1',
      type: QuestionType.matching,
      prompt: 'Upari pojam s objašnjenjem.',
      matchPairs: {
        'self.studenti = []': 'Svaki objekt dobiva svoju vlastitu listu',
        'lista=[] kao default parametar': 'Opasna greška - lista se dijeli između poziva',
        'lista=None + provjera unutar funkcije': 'Ispravan način postavljanja default liste',
        'studenti.sort(key=lambda s: s.ocjena)': 'Sortiranje liste objekata po atributu',
      },
    ),
    Question(
      id: 'lb34s2q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj zašto je "lista=[]" kao default parametar opasna - od definicije funkcije do posljedice.',
      hierarchyItems: [
        'Python stvara praznu listu SAMO JEDNOM, kad se funkcija definira',
        'Prvi poziv funkcije koristi tu istu listu i dodaje element',
        'Drugi poziv funkcije KORISTI ISTU listu (ne novu praznu)',
        'Lista se neočekivano "pamti" između poziva',
      ],
    ),
    Question(
      id: 'lb34s2q3',
      type: QuestionType.matching,
      prompt: 'Upari metodu klase Razred s onim što radi.',
      matchPairs: {
        'dodaj_studenta(student)': 'Dodaje objekt u internu listu studenti',
        'odlicni_studenti()': 'Vraća filtriranu listu objekata s ocjenom 5',
        'prosjek_razreda()': 'Računa prosjek preko svih objekata u listi',
        'self.studenti': 'Lista koja pripada instanci klase Razred',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Lista kao stog/red - implementacija
// ---------------------------------------------------------------------

final LessonSection listB34S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Klasa Stog - enkapsulacija liste',
      content: '''
Umjesto da svugdje u kodu ručno koristiš append()/pop() nad "golom" listom, možeš je "sakriti" unutar klase, koja nudi jasno imenovane metode:

class Stog:
    def __init__(self):
        self._elementi = []   # interna lista, "_" signalizira privatnost

    def push(self, x):
        self._elementi.append(x)

    def pop(self):
        return self._elementi.pop()

    def je_prazan(self):
        return len(self._elementi) == 0

s = Stog()
s.push(1)
s.push(2)
print(s.pop())   # 2

Ovo je primjer enkapsulacije - kod koji koristi Stog ne mora znati da je "ispod haube" obična lista, samo koristi push/pop/je_prazan metode.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Klasa Red - druga implementacija',
      content: '''
Slično stogu, red (queue) se može enkapsulirati u vlastitu klasu:

class Red:
    def __init__(self):
        self._elementi = []

    def dodaj(self, x):
        self._elementi.append(x)

    def ukloni(self):
        return self._elementi.pop(0)

    def je_prazan(self):
        return len(self._elementi) == 0

r = Red()
r.dodaj(1)
r.dodaj(2)
print(r.ukloni())   # 1 (prvi dodan, prvi uklonjen)

Napomena: pop(0) je spor za velike liste (O(n)) - u stvarnim aplikacijama koristi se collections.deque za brže redove.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Provjeravanje uravnoteženih zagrada - primjena stoga',
      content: '''
Klasičan problem koji se rješava stogom: provjera jesu li zagrade u izrazu ispravno uparene:

def zagrade_uravnotezene(izraz):
    stog = []
    parovi = {")": "(", "]": "[", "}": "{"}

    for znak in izraz:
        if znak in "([{":
            stog.append(znak)
        elif znak in ")]}":
            if not stog or stog.pop() != parovi[znak]:
                return False

    return len(stog) == 0

print(zagrade_uravnotezene("(a[b]{c})"))   # True
print(zagrade_uravnotezene("(a[b)"))       # False

Svaka OTVARAJUĆA zagrada se stavlja na stog; svaka ZATVARAJUĆA provjerava odgovara li zadnjoj otvorenoj.
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Povijest akcija - stog u praksi (undo)',
      content: '''
Stog je prirodan izbor za implementaciju "undo" funkcionalnosti - zadnja akcija je prva koja se poništava:

class PovijestAkcija:
    def __init__(self):
        self._akcije = []

    def izvrsi(self, akcija):
        self._akcije.append(akcija)
        print(f"Izvršeno: {akcija}")

    def poništi(self):
        if self._akcije:
            zadnja = self._akcije.pop()
            print(f"Poništeno: {zadnja}")

povijest = PovijestAkcija()
povijest.izvrsi("Dodaj tekst")
povijest.izvrsi("Obriši red")
povijest.poništi()   # Poništeno: Obriši red (zadnja akcija)
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Rekapitulacija - liste kao gradivni blok struktura',
      content: '''
Ova sekcija pokazala je kako se "gola" lista pretvara u imenovane, ponovno upotrebljive strukture:

1. Enkapsulacija liste unutar klase (Stog, Red) skriva implementacijske detalje
2. Metode poput push/pop/dodaj/ukloni daju jasnije značenje od golih append/pop
3. Stog rješava probleme poput provjere zagrada i undo funkcionalnosti
4. Red rješava probleme gdje je redoslijed obrade važan (FIFO)

Ovo pokazuje kako liste, iako jednostavne same po sebi, postaju moćan alat kad ih organiziraš unutar objektno orijentiranih struktura.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb34s3q1',
      type: QuestionType.matching,
      prompt: 'Upari metodu klase Stog s njenim djelovanjem.',
      matchPairs: {
        'push(x)': 'Dodaje x na vrh (append)',
        'pop()': 'Uklanja i vraća element s vrha',
        'je_prazan()': 'Provjerava je li lista prazna',
        '_elementi': 'Interna lista koja "sakriva" implementaciju',
      },
    ),
    Question(
      id: 'lb34s3q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake provjere zagrada "(a[b]{c})" pomoću stoga - konceptualno.',
      hierarchyItems: [
        'Kreni s praznim stogom',
        'Za svaku OTVARAJUĆU zagradu, stavi je na stog',
        'Za svaku ZATVARAJUĆU zagradu, skini zadnju sa stoga i usporedi',
        'Ako se sve zagrade poklapaju i stog je prazan na kraju, izraz je uravnotežen',
      ],
    ),
    Question(
      id: 'lb34s3q3',
      type: QuestionType.matching,
      prompt: 'Upari koncept s primjerom primjene stoga.',
      matchPairs: {
        'Provjera zagrada': 'Otvarajuće na stog, zatvarajuće uspoređuju i skidaju',
        'Undo funkcionalnost': 'Zadnja akcija je prva koja se poništava',
        'Red (queue)': 'Prvi dodan, prvi uklonjen - suprotno stogu',
        'Enkapsulacija': 'Skrivanje liste unutar klase s imenovanim metodama',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Napredne strukture s listama
// ---------------------------------------------------------------------

final LessonSection listB34S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Matrica kao klasa',
      content: '''
Matrica (lista listi) može se enkapsulirati u klasu koja nudi metode za rad s njom:

class Matrica:
    def __init__(self, redovi, stupci):
        self.redovi = redovi
        self.stupci = stupci
        self.podaci = [[0] * stupci for _ in range(redovi)]

    def postavi(self, r, s, vrijednost):
        self.podaci[r][s] = vrijednost

    def dohvati(self, r, s):
        return self.podaci[r][s]

m = Matrica(2, 2)
m.postavi(0, 0, 5)
print(m.dohvati(0, 0))   # 5

Napomena: [[0] * stupci for _ in range(redovi)] je VAŽAN obrazac - [0] * stupci * redovi bi stvorio DIJELJENE redove (sve bi bili ISTA lista), dok comprehension stvara SVAKI red kao NOVI, nezavisni objekt.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Graf kao rječnik lista',
      content: '''
Graf (mreža povezanih čvorova) često se predstavlja kao rječnik gdje je vrijednost svakog ključa LISTA susjeda:

graf = {
    "A": ["B", "C"],
    "B": ["A", "D"],
    "C": ["A"],
    "D": ["B"],
}

def susjedi(graf, cvor):
    return graf.get(cvor, [])

print(susjedi(graf, "A"))   # ["B", "C"]

Ova struktura (rječnik čije su vrijednosti liste) je temelj za algoritme pretrage grafova (BFS, DFS) - napredna tema koju ćeš sretati u kolegijima poput algoritama i struktura podataka.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Cache/memoizacija - rječnik s listama kao ključem',
      content: '''
Za funkcije koje se često pozivaju s ISTIM argumentima, rezultat se može "spremiti u cache" da se izbjegne ponovno računanje:

cache = {}

def spor_izracun(n):
    if n in cache:
        return cache[n]
    rezultat = n ** 2   # zamišljeno "sporo" računanje
    cache[n] = rezultat
    return rezultat

print(spor_izracun(5))   # računa i sprema
print(spor_izracun(5))   # čita iz cachea, brže

Ovaj obrazac (memoizacija) značajno ubrzava rekurzivne funkcije poput fibonaccija, gdje se isti pod-problemi inače računaju više puta.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Builder obrazac s listom koraka',
      content: '''
Klasa može interno graditi rezultat kroz listu "koraka" prije nego vrati konačan proizvod:

class UpitBuilder:
    def __init__(self):
        self._uvjeti = []

    def dodaj_uvjet(self, uvjet):
        self._uvjeti.append(uvjet)
        return self   # omogućuje ulančavanje poziva

    def izgradi(self):
        return " AND ".join(self._uvjeti)

upit = UpitBuilder().dodaj_uvjet("ocjena > 3").dodaj_uvjet("godina = 3").izgradi()
print(upit)   # "ocjena > 3 AND godina = 3"

return self unutar metode omogućuje "ulančavanje" (chaining) poziva - čest obrazac u modernim bibliotekama.
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - liste kao temelj složenih struktura',
      content: '''
Kroz ovu razinu naučila si kako liste postaju gradivni blok naprednijih struktura podataka:

1. Lista rječnika/objekata modelira kolekcije zapisa (poput tablice baze podataka)
2. Lista kao atribut klase - svaki objekt ima svoju vlastitu kolekciju
3. Enkapsulacija liste u klase poput Stog/Red daje jasnu, sigurnu upotrebu
4. Matrica (lista listi) i graf (rječnik listi) modeliraju složene odnose
5. Cache/memoizacija koristi rječnik za pamćenje već izračunatih rezultata

Sljedeća razina (Bloom 5-6) fokusira se na PISANJE algoritama koji rade nad listama - sortiranje, pretraga i slično, od nule.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb34s4q1',
      type: QuestionType.matching,
      prompt: 'Upari izraz s onim što stvara.',
      matchPairs: {
        '[[0] * stupci for _ in range(redovi)]': 'Matrica sa SVAKIM redom kao nezavisnim objektom',
        '[0] * stupci * redovi': 'Pogrešno - dijeljeni redovi (isti objekt više puta)',
        'graf = {"A": ["B", "C"]}': 'Rječnik čije su vrijednosti liste (graf)',
        'cache = {}': 'Struktura za pamćenje već izračunatih rezultata',
      },
    ),
    Question(
      id: 'lb34s4q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake korištenja memoizacije u funkciji spor_izracun(n).',
      hierarchyItems: [
        'Provjeri postoji li n već u cache rječniku',
        'Ako postoji, odmah vrati spremljenu vrijednost',
        'Ako ne postoji, izračunaj rezultat',
        'Spremi novi rezultat u cache prije vraćanja',
      ],
    ),
    Question(
      id: 'lb34s4q3',
      type: QuestionType.matching,
      prompt: 'Upari strukturu s njenom primjenom.',
      matchPairs: {
        'Rječnik lista (graf)': 'Predstavljanje povezanih čvorova/susjeda',
        'Lista listi (matrica)': 'Predstavljanje dvodimenzionalnih podataka',
        'Builder s return self': 'Omogućuje ulančavanje poziva metoda',
        'Cache (rječnik)': 'Ubrzava ponovljene izračune istih vrijednosti',
      },
    ),
  ],
);

final Lesson listeBloom34 = Lesson(
  id: 202,
  title: 'Liste - Strukture podataka i OOP',
  bloomLevels: '3-4',
  questionType: QuestionType.matching,
  sections: [listB34S1, listB34S2, listB34S3, listB34S4],
);