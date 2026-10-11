// lib/models/liste/bloom12.dart
//
// Tema LISTE — Bloom 1-2 (Pamćenje/Razumijevanje)
// Osnovno objašnjenje liste. Objektivna pitanja.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Osnove liste
// ---------------------------------------------------------------------

final LessonSection listB12S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Što je lista?',
      content: '''
Lista je uređena kolekcija podataka koja može sadržavati elemente različitih tipova, a stvara se uglatim zagradama:

brojevi = [1, 2, 3, 4, 5]
mjesoviti = ["Split", 21, 3.14, True]
prazna = []

Za razliku od int, float, str ili bool (koji su immutable), lista je MUTABLE - njen sadržaj se može mijenjati NAKON stvaranja, bez stvaranja novog objekta u memoriji. Lista u memoriji zapravo sadrži niz referenci (pokazivača) na objekte, ne same objekte direktno.

Ovo ima praktičnu posljedicu: ako dvije varijable pokazuju na istu listu, promjena preko jedne varijable vidljiva je i preko druge - jer obje pokazuju na isti objekt u memoriji.
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Indeksiranje - pristup pojedinom elementu',
      content: '''
Elementima liste pristupa se preko indeksa, počevši od 0:

brojevi = [10, 20, 30, 40, 50]
print(brojevi[0])    # 10 (prvi element)
print(brojevi[2])    # 30 (treći element)
print(brojevi[-1])   # 50 (zadnji element, negativni indeksi broje od kraja)
print(brojevi[-2])   # 40 (pretzadnji)

Ako pokušaš pristupiti indeksu koji ne postoji (npr. brojevi[10] kad lista ima 5 elemenata), Python baca IndexError.

Duljinu liste (broj elemenata) dobiješ funkcijom len():

print(len(brojevi))   # 5
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Slicing - rezanje liste',
      content: '''
Slicing omogućuje dohvaćanje DIJELA liste odjednom, koristeći sintaksu lista[početak:kraj]:

brojevi = [10, 20, 30, 40, 50]

print(brojevi[1:3])   # [20, 30]  - od indeksa 1 do 3 (isključivo)
print(brojevi[:2])    # [10, 20]  - od početka do indeksa 2
print(brojevi[2:])    # [30, 40, 50] - od indeksa 2 do kraja
print(brojevi[:])     # [10, 20, 30, 40, 50] - kopija cijele liste
print(brojevi[::2])   # [10, 30, 50] - svaki drugi element (korak 2)
print(brojevi[::-1])  # [50, 40, 30, 20, 10] - obrnuti redoslijed

brojevi[:] (slicing bez granica) je čest način za stvaranje PRAVE kopije liste, jer vraća novi objekt umjesto reference na postojeći.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Mijenjanje elemenata liste',
      content: '''
Za razliku od stringova, elementi liste mogu se izravno mijenjati preko indeksa:

ocjene = [3, 4, 3, 5]
ocjene[0] = 5   # mijenja prvi element -> [5, 4, 3, 5]

Ovo radi jer je lista mutable - mijenja se SADRŽAJ na istom mjestu u memoriji, ne stvara se novi objekt liste. Cijela lista zadržava istu memorijsku adresu (id(ocjene) ostaje isti prije i poslije ove izmjene).

Također možeš mijenjati više elemenata odjednom preko slicinga:

ocjene[1:3] = [1, 1]   # zamjenjuje elemente na indeksima 1 i 2 -> [5, 1, 1, 5]
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Provjera pripadnosti i pretraga',
      content: '''
Operator in provjerava nalazi li se element unutar liste:

imena = ["Ana", "Marko", "Ivana"]
print("Ana" in imena)        # True
print("Petra" in imena)      # False
print("Petra" not in imena)  # True

Metoda .index() vraća poziciju PRVOG pojavljivanja elementa (baca grešku ako element ne postoji):

pozicija = imena.index("Marko")   # 1

Metoda .count() broji koliko se puta element pojavljuje u listi:

ocjene = [5, 4, 5, 5, 3]
print(ocjene.count(5))   # 3
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb12s1q1',
      type: QuestionType.objective,
      prompt: 'Zašto se lista naziva "mutable" tipom podataka?',
      options: [
        'Jer se ne može ispisati na ekran',
        'Jer se njen sadržaj može mijenjati bez stvaranja novog objekta u memoriji',
        'Jer uvijek sadrži samo brojeve',
        'Jer se automatski briše nakon korištenja',
      ],
      correctAnswer: 'Jer se njen sadržaj može mijenjati bez stvaranja novog objekta u memoriji',
    ),
    Question(
      id: 'lb12s1q2',
      type: QuestionType.objective,
      prompt: 'Što vraća brojevi[-1] za listu brojevi = [10, 20, 30]?',
      options: ['10', '30', 'Grešku', 'None'],
      correctAnswer: '30',
    ),
    Question(
      id: 'lb12s1q3',
      type: QuestionType.objective,
      prompt: 'Što vraća izraz brojevi[::-1] za brojevi = [1, 2, 3]?',
      options: ['[1, 2, 3]', '[3, 2, 1]', '[]', 'Grešku'],
      correctAnswer: '[3, 2, 1]',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Metode liste
// ---------------------------------------------------------------------

final LessonSection listB12S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Dodavanje elemenata',
      content: '''
Budući da je lista mutable, ima ugrađene metode koje mijenjaju njen sadržaj IN-PLACE (na istom mjestu u memoriji):

lista = [1, 2, 3]
lista.append(4)         # dodaje na kraj -> [1, 2, 3, 4]
lista.insert(0, 0)       # dodaje na poziciju 0 -> [0, 1, 2, 3, 4]
lista.extend([5, 6])     # dodaje VIŠE elemenata na kraj -> [0, 1, 2, 3, 4, 5, 6]

Razlika između append() i extend(): append() dodaje CIJELI argument kao JEDAN element, dok extend() "raspakira" argument i dodaje svaki element posebno:

a = [1, 2]
a.append([3, 4])   # [1, 2, [3, 4]] - lista unutar liste!
b = [1, 2]
b.extend([3, 4])   # [1, 2, 3, 4] - svi elementi dodani zasebno
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Uklanjanje elemenata',
      content: '''
Postoji nekoliko načina za uklanjanje elemenata iz liste:

lista = [10, 20, 30, 40]

lista.remove(20)       # uklanja PRVU pojavu VRIJEDNOSTI 20 -> [10, 30, 40]
zadnji = lista.pop()    # uklanja i VRAĆA zadnji element -> zadnji = 40
prvi = lista.pop(0)     # uklanja i vraća element na indeksu 0
del lista[0]             # briše element na indeksu, ne vraća ga
lista.clear()            # briše SVE elemente -> []

Bitna razlika: remove() traži po VRIJEDNOSTI (baca grešku ako vrijednost ne postoji), dok pop() i del rade po INDEKSU.
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Sortiranje liste',
      content: '''
Metoda .sort() sortira listu IN-PLACE:

brojevi = [5, 2, 8, 1, 9]
brojevi.sort()              # [1, 2, 5, 8, 9]
brojevi.sort(reverse=True)  # [9, 8, 5, 2, 1]

Funkcija sorted() vraća NOVU sortiranu listu, ostavljajući originalnu nepromijenjenom:

originalna = [5, 2, 8]
nova = sorted(originalna)
print(originalna)   # [5, 2, 8] - nepromijenjena!
print(nova)          # [2, 5, 8]
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Reverse i copy',
      content: '''
Metoda .reverse() obrće redoslijed elemenata IN-PLACE:

lista = [1, 2, 3, 4]
lista.reverse()   # [4, 3, 2, 1]

Za kopiranje liste, VAŽNO je razlikovati dodjelu od prave kopije:

a = [1, 2, 3]
b = a             # b NIJE kopija! b i a pokazuju na ISTI objekt u memoriji
b.append(4)
print(a)          # [1, 2, 3, 4] - i a se "promijenio"!

c = a.copy()      # c JEST prava kopija - nova lista u memoriji
c.append(5)
print(a)          # [1, 2, 3, 4] - a ostaje nepromijenjen
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Spajanje i množenje liste',
      content: '''
Liste se mogu spajati operatorom +, koji stvara NOVU listu:

a = [1, 2]
b = [3, 4]
spojeno = a + b   # [1, 2, 3, 4]

Operator * ponavlja listu zadani broj puta:

ponovljeno = [0] * 5   # [0, 0, 0, 0, 0]
matrica_red = [1, 2] * 3   # [1, 2, 1, 2, 1, 2]

Ovo je čest način za brzo stvaranje liste zadane duljine ispunjene istom vrijednošću.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb12s2q1',
      type: QuestionType.objective,
      prompt: 'Koja metoda dodaje element na KRAJ liste?',
      options: ['insert()', 'append()', 'add()', 'push()'],
      correctAnswer: 'append()',
    ),
    Question(
      id: 'lb12s2q2',
      type: QuestionType.objective,
      prompt: 'Nakon a = [1,2]; a.append([3,4]) - koliko elemenata ima lista a?',
      options: ['2', '3', '4', 'Greška'],
      correctAnswer: '3',
    ),
    Question(
      id: 'lb12s2q3',
      type: QuestionType.objective,
      prompt: 'Koja funkcija vraća NOVU sortiranu listu, ostavljajući original nepromijenjenim?',
      options: ['lista.sort()', 'sorted(lista)', 'lista.reverse()', 'lista.order()'],
      correctAnswer: 'sorted(lista)',
    ),
    Question(
      id: 'lb12s2q4',
      type: QuestionType.objective,
      prompt: 'Nakon a=[1,2,3]; b=a; b.append(4) - koliko elemenata ima a?',
      options: ['3', '4', '0', 'Greška'],
      correctAnswer: '4',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Iteracija i ugniježđene liste
// ---------------------------------------------------------------------

final LessonSection listB12S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'for petlja kroz listu',
      content: '''
for petlja omogućuje prolazak kroz svaki element liste:

imena = ["Ana", "Marko", "Ivana"]
for ime in imena:
    print(ime)

Ako trebaš i indeks svakog elementa, koristi enumerate():

for i, ime in enumerate(imena):
    print(i, ime)   # 0 Ana, 1 Marko, 2 Ivana
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'List comprehension',
      content: '''
List comprehension je kompaktan način za stvaranje nove liste iz postojeće:

brojevi = [1, 2, 3, 4, 5]
kvadrati = [x ** 2 for x in brojevi]   # [1, 4, 9, 16, 25]
parni = [x for x in brojevi if x % 2 == 0]   # [2, 4]

Ovo je ekvivalentno duljem zapisu s for petljom i append() pozivima, ali čitljivije i često brže.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Ugniježđene liste (matrice)',
      content: '''
Elementi liste mogu i sami biti liste - matrica:

matrica = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

print(matrica[0])       # [1, 2, 3]
print(matrica[0][1])    # 2

for red in matrica:
    for element in red:
        print(element, end=" ")
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Zip - kombiniranje više lista',
      content: '''
zip() spaja više lista u parove, omogućujući iteraciju kroz njih ISTOVREMENO:

imena = ["Ana", "Marko"]
ocjene = [5, 4]

for ime, ocjena in zip(imena, ocjene):
    print(f"{ime}: {ocjena}")

Ako liste nisu iste duljine, zip() staje na kraju KRAĆE liste.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Uklanjanje duplikata',
      content: '''
Najjednostavniji način koristi set:

lista = [1, 2, 2, 3, 3, 3]
jedinstveni = list(set(lista))   # [1, 2, 3] (redoslijed nije zajamčen)

Ako je redoslijed bitan, koristi se list comprehension s provjerom je li element već viđen.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb12s3q1',
      type: QuestionType.objective,
      prompt: 'Što vraća enumerate() unutar for petlje?',
      options: [
        'Samo vrijednosti',
        'Samo indekse',
        'Par (indeks, vrijednost)',
        'Broj elemenata',
      ],
      correctAnswer: 'Par (indeks, vrijednost)',
    ),
    Question(
      id: 'lb12s3q2',
      type: QuestionType.objective,
      prompt: 'Što vraća [x**2 for x in [1,2,3]]?',
      options: ['[1, 2, 3]', '[1, 4, 9]', '[2, 4, 6]', 'Greška'],
      correctAnswer: '[1, 4, 9]',
    ),
    Question(
      id: 'lb12s3q3',
      type: QuestionType.objective,
      prompt: 'Za matrica = [[1,2],[3,4]], što vraća matrica[1][0]?',
      options: ['1', '2', '3', '4'],
      correctAnswer: '3',
    ),
    Question(
      id: 'lb12s3q4',
      type: QuestionType.objective,
      prompt: 'Što je najjednostavniji način uklanjanja duplikata iz liste (bez čuvanja redoslijeda)?',
      options: ['list(set(lista))', 'lista.unique()', 'lista.remove_duplicates()', 'sorted(lista)'],
      correctAnswer: 'list(set(lista))',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Napredni obrasci
// ---------------------------------------------------------------------

final LessonSection listB12S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Ugrađene funkcije nad listama',
      content: '''
Python nudi ugrađene funkcije koje rade direktno nad listama brojeva:

brojevi = [5, 2, 8, 1, 9]

print(sum(brojevi))    # 25
print(max(brojevi))    # 9
print(min(brojevi))    # 1
print(len(brojevi))    # 5

Ove funkcije su implementirane u C-u "ispod haube", pa su brže od ekvivalentne ručno pisane petlje.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'any() i all()',
      content: '''
any() vraća True ako BAREM JEDAN element zadovoljava uvjet, all() vraća True samo ako SVI elementi zadovoljavaju uvjet:

ocjene = [4, 5, 3, 5, 2]

ima_petica = any(x == 5 for x in ocjene)     # True
svi_prolazni = all(x >= 2 for x in ocjene)   # True
svi_odlicni = all(x == 5 for x in ocjene)     # False
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Pretraga i filtriranje',
      content: '''
Filtriranje liste najčešće se radi list comprehensionom:

studenti = [
    {"ime": "Ana", "ocjena": 5},
    {"ime": "Marko", "ocjena": 3},
]

odlicni = [s for s in studenti if s["ocjena"] == 5]

Za pronalazak PRVOG elementa koji zadovoljava uvjet, koristi se next() s generatorom:

prvi_odlican = next((s for s in studenti if s["ocjena"] == 5), None)
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Liste kao redovi i stogovi',
      content: '''
STOG (stack) - "zadnji ušao, prvi izašao". append() dodaje na vrh, pop() uklanja s vrha:

stog = []
stog.append(1)
stog.append(2)
print(stog.pop())   # 2

RED (queue) - "prvi ušao, prvi izašao". append() dodaje na kraj, pop(0) uklanja s početka:

red = []
red.append(1)
red.append(2)
print(red.pop(0))   # 1
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - liste u praksi',
      content: '''
Kroz ovu razinu naučila si sve ključne operacije nad listama:

1. Lista je MUTABLE, uređena kolekcija
2. Indeksiranje i slicing pristupaju elementima
3. append/insert/extend dodaju, remove/pop/del/clear uklanjaju
4. sort() mijenja in-place, sorted() vraća novu listu
5. List comprehension gradi nove liste kompaktno
6. Ugniježđene liste modeliraju 2D podatke (matrice)

Sljedeća razina (Bloom 3-4) pokazuje kako se liste organiziraju u složenije strukture i objekte.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb12s4q1',
      type: QuestionType.objective,
      prompt: 'Koja funkcija vraća najveći element liste?',
      options: ['sum()', 'max()', 'len()', 'top()'],
      correctAnswer: 'max()',
    ),
    Question(
      id: 'lb12s4q2',
      type: QuestionType.objective,
      prompt: 'Što vraća any(x == 5 for x in [1,2,3])?',
      options: ['True', 'False', '5', 'Greška'],
      correctAnswer: 'False',
    ),
    Question(
      id: 'lb12s4q3',
      type: QuestionType.objective,
      prompt: 'Koja kombinacija metoda implementira STOG (LIFO)?',
      options: ['append() + pop()', 'append() + pop(0)', 'insert() + remove()', 'extend() + clear()'],
      correctAnswer: 'append() + pop()',
    ),
    Question(
      id: 'lb12s4q4',
      type: QuestionType.objective,
      prompt: 'Koja kombinacija metoda implementira RED (FIFO)?',
      options: ['append() + pop()', 'append() + pop(0)', 'insert(0) + pop()', 'sort() + reverse()'],
      correctAnswer: 'append() + pop(0)',
    ),
    Question(
      id: 'lb12s4q5',
      type: QuestionType.objective,
      prompt: 'Koja funkcija pronalazi PRVI element koji zadovoljava uvjet, iz generatora?',
      options: ['first()', 'next()', 'find()', 'search()'],
      correctAnswer: 'next()',
    ),
  ],
);

final Lesson listeBloom12 = Lesson(
  id: 201,
  title: 'Liste - Osnove',
  bloomLevels: '1-2',
  questionType: QuestionType.objective,
  sections: [listB12S1, listB12S2, listB12S3, listB12S4],
);