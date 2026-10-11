// lib/models/ifelse/bloom12.dart
//
// Tema IF/ELSE — Bloom 1-2 (Pamćenje/Razumijevanje)
// Osnovno objašnjenje uvjeta i petlji. Objektivna pitanja.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — if/elif/else
// ---------------------------------------------------------------------

final LessonSection ifB12S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Operatori usporedbe i logički operatori',
      content: '''
Prije uvjeta, upoznajmo operatore koji vraćaju bool (True/False):

==  jednako          5 == 5   -> True
!=  nije jednako      5 != 3   -> True
>   veće              5 > 3    -> True
<   manje             5 < 3    -> False
>=  veće ili jednako
<=  manje ili jednako

Logički operatori kombiniraju uvjete:

and  - True samo ako su OBA uvjeta True
or   - True ako je BAREM JEDAN uvjet True
not  - obrće vrijednost

Primjer:
godine = 20
ima_iskaznicu = True
print(godine >= 18 and ima_iskaznicu)   # True
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'if - osnovni uvjet',
      content: '''
if izvršava blok koda SAMO AKO je uvjet True:

temperatura = 30
if temperatura > 25:
    print("Toplo je")

Ako uvjet nije True, blok se jednostavno preskače. Uvlačenje (indentation) je OBAVEZNO u Pythonu - njime se određuje koji kod pripada if bloku.

temperatura = 10
if temperatura > 25:
    print("Toplo je")
print("Ovo se ispisuje uvijek")   # NIJE dio if bloka
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'if / else - dvije mogućnosti',
      content: '''
else definira što se izvršava kad uvjet NIJE True:

temperatura = 10
if temperatura > 25:
    print("Toplo je")
else:
    print("Nije toplo")

Uvijek se izvrši TOČNO JEDAN od ova dva bloka. else nema svoj uvjet - automatski "hvata" sve slučajeve gdje if uvjet nije bio zadovoljen.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'elif - više mogućnosti',
      content: '''
elif omogućuje provjeru VIŠE uvjeta redom:

temperatura = 15

if temperatura > 25:
    print("Toplo je")
elif temperatura > 10:
    print("Umjereno je")
else:
    print("Hladno je")

Python provjerava uvjete redom odozgo prema dolje. ČIM jedan uvjet bude True, izvrši se pripadajući blok i OSTATAK se preskače.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Ugniježđeni uvjeti',
      content: '''
Uvjeti mogu biti ugniježđeni kad je logika složenija:

ocjena = 85
prisutnost = 90

if ocjena >= 60:
    if prisutnost >= 80:
        print("Položio si kolegij")
    else:
        print("Nemaš dovoljno prisutnosti")
else:
    print("Nisi položio")

Alternativno, kompaktnije s and:

if ocjena >= 60 and prisutnost >= 80:
    print("Položio si kolegij")
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib12s1q1',
      type: QuestionType.objective,
      prompt: 'Koji operator provjerava jesu li OBA uvjeta istinita?',
      options: ['or', 'not', 'and', '=='],
      correctAnswer: 'and',
    ),
    Question(
      id: 'ib12s1q2',
      type: QuestionType.objective,
      prompt: 'Čime se u Pythonu određuje koji kod pripada kojem if/else bloku?',
      options: ['Vitičastim zagradama {}', 'Uvlačenjem (indentation)', 'Točkom-zarezom ;', 'Ključnom riječi end'],
      correctAnswer: 'Uvlačenjem (indentation)',
    ),
    Question(
      id: 'ib12s1q3',
      type: QuestionType.objective,
      prompt: 'Koliko blokova se MAKSIMALNO izvrši u if/elif/else lancu?',
      options: ['Jedan', 'Svi koji su True', 'Nijedan', 'Uvijek svi'],
      correctAnswer: 'Jedan',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — for petlja
// ---------------------------------------------------------------------

final LessonSection ifB12S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'for petlja - osnove',
      content: '''
for petlja ponavlja blok koda za svaki element kolekcije:

imena = ["Ana", "Marko", "Ivana"]
for ime in imena:
    print(ime)

Svaka iteracija petlje, varijabla ime poprima vrijednost sljedećeg elementa liste, sve dok se ne prođe kroz sve elemente.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'range() - petlja s brojem ponavljanja',
      content: '''
Kad trebaš ponoviti nešto točno određen broj puta, koristi range():

for i in range(5):
    print(i)   # 0, 1, 2, 3, 4

range(2, 10, 2) generira brojeve od 2 do 8 s korakom 2. range(početak, kraj, korak) - kraj je UVIJEK isključen.
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'while petlja',
      content: '''
while petlja ponavlja blok koda SVE DOK je uvjet True:

brojac = 0
while brojac < 5:
    print(brojac)
    brojac += 1   # OBAVEZNO mijenjati uvjet, inače beskonačna petlja!

Ako zaboraviš mijenjati varijablu u uvjetu, petlja se nikad ne zaustavlja.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'break i continue',
      content: '''
break odmah PREKIDA petlju:

for i in range(10):
    if i == 5:
        break
    print(i)   # 0, 1, 2, 3, 4

continue PRESKAČE trenutnu iteraciju:

for i in range(5):
    if i == 2:
        continue
    print(i)   # 0, 1, 3, 4
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'else uz petlju',
      content: '''
else blok uz for/while izvršava se SAMO ako petlja završi NORMALNO (bez break):

for i in range(5):
    if i == 10:
        break
    print(i)
else:
    print("Petlja je završila bez prekida")   # ovo SE ispisuje

Ako bi petlja bila prekinuta break-om, else blok bi bio PRESKOČEN.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib12s2q1',
      type: QuestionType.objective,
      prompt: 'Što ispisuje range(1, 5)?',
      options: ['1,2,3,4', '1,2,3,4,5', '0,1,2,3,4', '2,3,4,5'],
      correctAnswer: '1,2,3,4',
    ),
    Question(
      id: 'ib12s2q2',
      type: QuestionType.objective,
      prompt: 'Što se dogodi ako u while petlji zaboraviš mijenjati uvjet?',
      options: ['Petlja se izvrši jednom', 'Nastaje beskonačna petlja', 'Python baca grešku odmah', 'Petlja se preskače'],
      correctAnswer: 'Nastaje beskonačna petlja',
    ),
    Question(
      id: 'ib12s2q3',
      type: QuestionType.objective,
      prompt: 'Što radi continue unutar petlje?',
      options: ['Prekida cijelu petlju', 'Preskače trenutnu iteraciju', 'Ponavlja trenutnu iteraciju', 'Završava program'],
      correctAnswer: 'Preskače trenutnu iteraciju',
    ),
    Question(
      id: 'ib12s2q4',
      type: QuestionType.objective,
      prompt: 'Kad se izvršava else blok uz for petlju?',
      options: ['Uvijek nakon petlje', 'Samo ako je petlja prekinuta break-om', 'Samo ako petlja NIJE prekinuta break-om', 'Nikad'],
      correctAnswer: 'Samo ako petlja NIJE prekinuta break-om',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Akumulacija i pretraga
// ---------------------------------------------------------------------

final LessonSection ifB12S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Zbrajanje u petlji (akumulacija)',
      content: '''
Postupno gomilanje rezultata kroz iteracije petlje:

brojevi = [3, 7, 2, 9, 4]
suma = 0
for broj in brojevi:
    suma += broj
print(suma)   # 25

Varijabla suma se inicijalizira PRIJE petlje (na 0), a zatim se ažurira u svakoj iteraciji.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Brojanje u petlji',
      content: '''
Varijabla-brojač koja se povećava kad je zadovoljen neki uvjet:

ocjene = [5, 3, 4, 5, 2, 5]
broj_petica = 0
for ocjena in ocjene:
    if ocjena == 5:
        broj_petica += 1
print(broj_petica)   # 3
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Pronalaženje maksimuma ručno',
      content: '''
def najveci(brojevi):
    najveci = brojevi[0]
    for broj in brojevi:
        if broj > najveci:
            najveci = broj
    return najveci

Ključna ideja: kreni s PRETPOSTAVKOM (prvi element), zatim uspoređuj svaki sljedeći i AŽURIRAJ kad nađeš bolji kandidat.
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Pretraga elementa',
      content: '''
brojevi = [4, 8, 15, 16, 23]
trazeni = 15
pronaden = False

for broj in brojevi:
    if broj == trazeni:
        pronaden = True
        break

if pronaden:
    print("Pronađen")
else:
    print("Nije pronađen")

break je bitan - čim pronađeš traženo, nema razloga nastaviti.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Ugniježđene petlje - tablica množenja',
      content: '''
for i in range(1, 4):
    for j in range(1, 4):
        print(f"{i} x {j} = {i*j}")

Vanjska petlja se izvrši jednom po vrijednosti i, a za svaku, unutarnja petlja prođe kroz sve svoje vrijednosti j.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib12s3q1',
      type: QuestionType.objective,
      prompt: 'Koja je početna vrijednost akumulatora za zbrajanje?',
      options: ['1', '0', 'None', '-1'],
      correctAnswer: '0',
    ),
    Question(
      id: 'ib12s3q2',
      type: QuestionType.objective,
      prompt: 'Zašto je break bitan u petlji za pretragu elementa?',
      options: [
        'Nije bitan, petlja radi isto bez njega',
        'Zaustavlja petlju čim se nešto pronađe, štedi vrijeme',
        'Sprječava beskonačnu petlju',
        'Povećava brojač',
      ],
      correctAnswer: 'Zaustavlja petlju čim se nešto pronađe, štedi vrijeme',
    ),
    Question(
      id: 'ib12s3q3',
      type: QuestionType.objective,
      prompt: 'Koliko se ispisa dogodi u dvije ugniježđene for petlje, svaka range(1,4)?',
      options: ['3', '6', '9', '12'],
      correctAnswer: '9',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Kombiniranje uvjeta i petlji
// ---------------------------------------------------------------------

final LessonSection ifB12S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'FizzBuzz - klasičan zadatak',
      content: '''
for i in range(1, 16):
    if i % 3 == 0 and i % 5 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)

Redoslijed uvjeta je KLJUČAN - "djeljivo s OBA" mora doći PRVA.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Provjera je li broj prost',
      content: '''
def je_prost(n):
    if n < 2:
        return False
    for i in range(2, n):
        if n % i == 0:
            return False
    return True

return unutar petlje odmah prekida i funkciju i petlju.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Obrtanje stringa petljom',
      content: '''
tekst = "Split"
obrnuto = ""
for znak in tekst:
    obrnuto = znak + obrnuto
print(obrnuto)   # "tilpS"

Svaki novi znak ide NA POČETAK, čime se redoslijed prirodno obrne.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Kombiniranje liste i petlje s uvjetima',
      content: '''
ocjene = [5, 1, 4, 2, 5, 1, 3]
prolazne = []
for ocjena in ocjene:
    if ocjena >= 2:
        prolazne.append(ocjena)

if len(prolazne) > 0:
    prosjek = sum(prolazne) / len(prolazne)
    print(f"Prosjek: {prosjek:.2f}")

Provjera len(prolazne) > 0 PRIJE dijeljenja sprječava ZeroDivisionError.
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - temelj programa',
      content: '''
1. if/elif/else donosi odluke - izvršava se točno jedna grana
2. for petlja ide kroz poznatu kolekciju ili range()
3. while petlja ponavlja dok je uvjet True
4. break prekida petlju, continue preskače iteraciju
5. Akumulacija gradi rezultat kroz iteracije
6. Kombinacija if + petlja + lista rješava većinu praktičnih zadataka

Sljedeća razina (Bloom 3-4) pokazuje kako se uvjeti i petlje organiziraju unutar objekata i struktura.
''',
    ),
  ],
  questions: [
    Question(
      id: 'ib12s4q1',
      type: QuestionType.objective,
      prompt: 'U FizzBuzz kodu, zašto uvjet "djeljivo s OBA (3 i 5)" mora biti PRVI?',
      options: [
        'Nije bitno, redoslijed ne utječe',
        'Jer bi ga inače elif za 3 ili 5 "uhvatio" prije',
        'Python zahtijeva alfabetski redoslijed',
        'Radi brzine izvođenja',
      ],
      correctAnswer: 'Jer bi ga inače elif za 3 ili 5 "uhvatio" prije',
    ),
    Question(
      id: 'ib12s4q2',
      type: QuestionType.objective,
      prompt: 'Zašto return unutar petlje u je_prost() ne treba dodatni break?',
      options: [
        'return ionako ne prekida ništa',
        'return odmah izlazi iz cijele funkcije, uključujući petlju',
        'break bi izazvao grešku',
        'Nema razlike, oboje se mora koristiti',
      ],
      correctAnswer: 'return odmah izlazi iz cijele funkcije, uključujući petlju',
    ),
    Question(
      id: 'ib12s4q3',
      type: QuestionType.objective,
      prompt: 'Zašto se provjerava len(prolazne) > 0 prije računanja prosjeka?',
      options: [
        'Radi brzine',
        'Da se izbjegne ZeroDivisionError kod dijeljenja s 0',
        'Python to zahtijeva sintaksno',
        'Nije potrebno, to je stilski izbor',
      ],
      correctAnswer: 'Da se izbjegne ZeroDivisionError kod dijeljenja s 0',
    ),
  ],
);

final Lesson ifelseBloom12 = Lesson(
  id: 301,
  title: 'If/else - Osnove',
  bloomLevels: '1-2',
  questionType: QuestionType.objective,
  sections: [ifB12S1, ifB12S2, ifB12S3, ifB12S4],
);