// lib/models/varijable/bloom34.dart
//
// Tema VARIJABLE — Bloom 3-4 (Primjena/Analiza)
// Kako se varijable organiziraju u strukture podataka i objekte.
// Pitanja: uparivanje i slaganje hijerarhije.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Rječnici (dict)
// ---------------------------------------------------------------------

final LessonSection varB34S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Što je rječnik (dict)?',
      content: '''
Rječnik je kolekcija parova ključ-vrijednost - grupira više VARIJABLI (vrijednosti) pod smislenim imenima (ključevima) u JEDAN objekt:

student = {
    "ime": "Danijel",
    "godina": 3,
    "smjer": "Strojarstvo"
}

print(student["ime"])   # Danijel

U memoriji, rječnik je implementiran kao hash tablica - svaki ključ se pretvara u hash vrijednost koja određuje gdje se sprema par ključ-vrijednost. Umjesto da imaš tri odvojene varijable (ime, godina, smjer), grupiraš ih u jednu logičku cjelinu.
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Dodavanje, mijenjanje i brisanje',
      content: '''
Rječnik je mutable, pa se lako mijenja nakon stvaranja:

student["godina"] = 4          # mijenja postojeći ključ
student["prosjek"] = 4.2       # dodaje novi ključ
del student["smjer"]           # briše ključ i njegovu vrijednost

Provjera postoji li ključ:

if "ime" in student:
    print("Ključ postoji")

Metoda .get() je sigurniji način dohvaćanja vrijednosti - ne baca grešku ako ključ ne postoji, nego vraća None (ili zadanu vrijednost):

print(student.get("prezime"))          # None
print(student.get("prezime", "N/A"))   # N/A
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Iteracija kroz rječnik',
      content: '''
Kroz rječnik se može iterirati na nekoliko načina:

for kljuc in student:
    print(kljuc)                     # ispisuje samo ključeve

for kljuc, vrijednost in student.items():
    print(kljuc, "->", vrijednost)   # ispisuje parove

for vrijednost in student.values():
    print(vrijednost)                # ispisuje samo vrijednosti

.items() vraća parove kao tuple objekte, .keys() vraća samo ključeve, a .values() samo vrijednosti. Redoslijed iteracije odgovara redoslijedu kojim su ključevi dodani u rječnik.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Ugniježđeni rječnici',
      content: '''
Rječnici mogu sadržavati druge rječnike ili liste kao vrijednosti, što omogućuje modeliranje složenijih struktura podataka:

studenti = {
    "student1": {"ime": "Ana", "ocjene": [4, 5, 3]},
    "student2": {"ime": "Marko", "ocjene": [5, 5, 4]}
}

print(studenti["student1"]["ime"])          # Ana
print(studenti["student2"]["ocjene"][0])    # 5

Ovakva ugniježđena struktura odgovara npr. JSON formatu, koji se često koristi za razmjenu podataka između aplikacije i servera (npr. Supabase vraća podatke točno u ovakvom obliku).
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Kada koristiti rječnik, a kada listu?',
      content: '''
Odabir strukture ovisi o tome kako pristupaš podacima:

Koristi LISTU kad:
- redoslijed elemenata je bitan
- pristupaš elementima preko pozicije (indeksa)
- elementi su "iste vrste"

Koristi RJEČNIK kad:
- svaki podatak ima smisleno ime/oznaku (ključ)
- trebaš brz pristup preko tog imena, ne preko pozicije
- modeliraš "objekt" sa svojstvima (npr. jedan student sa svim svojim varijablama)

U praksi se često kombiniraju - npr. lista rječnika za popis studenata, gdje je svaki student jedan rječnik s ključevima "ime", "godina", itd.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb34s1q1',
      type: QuestionType.matching,
      prompt: 'Upari pojam s njegovim opisom.',
      matchPairs: {
        'dict': 'Kolekcija parova ključ-vrijednost',
        '.get()': 'Sigurno dohvaćanje vrijednosti bez greške',
        '.items()': 'Vraća parove ključ-vrijednost za iteraciju',
        'hash tablica': 'Način na koji je rječnik implementiran u memoriji',
      },
    ),
    Question(
      id: 'vb34s1q2',
      type: QuestionType.matching,
      prompt: 'Upari operaciju s njenim rezultatom za student = {"ime": "Ana"}.',
      matchPairs: {
        'student.get("prezime")': 'None',
        'student["ime"]': '"Ana"',
        '"ime" in student': 'True',
        'del student["ime"]': 'Uklanja ključ "ime" iz rječnika',
      },
    ),
    Question(
      id: 'vb34s1q3',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake pristupa vrijednosti u ugniježđenom rječniku studenti["student1"]["ocjene"][0].',
      hierarchyItems: [
        'Pronađi ključ "student1" u vanjskom rječniku',
        'Dohvati unutarnji rječnik vezan za "student1"',
        'Pronađi ključ "ocjene" u unutarnjem rječniku',
        'Dohvati listu ocjena',
        'Dohvati element na indeksu 0 te liste',
      ],
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Tuple i set
// ---------------------------------------------------------------------

final LessonSection varB34S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Tuple - nepromjenjiva grupa varijabli',
      content: '''
Tuple je slična listi (uređena kolekcija, pristup preko indeksa), ali je immutable - jednom stvorena, ne može se mijenjati:

koordinate = (45.5, 16.3)
print(koordinate[0])   # 45.5

koordinate[0] = 50   # GREŠKA! tuple se ne može mijenjati

Zašto koristiti tuple umjesto liste? Kad želiš osigurati da se podaci NE MOGU slučajno promijeniti tijekom izvođenja programa (npr. fiksne koordinate, RGB boja). Tuple je i nešto brži i troši manje memorije od liste.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Raspakiravanje tuplea (unpacking)',
      content: '''
Tuple omogućuje elegantno raspakiravanje više vrijednosti odjednom u zasebne varijable:

koordinate = (45.5, 16.3)
lat, lon = koordinate
print(lat)   # 45.5
print(lon)   # 16.3

Ovo se često koristi kod iteracije kroz rječnik pomoću .items(), koji vraća tuple parove:

for kljuc, vrijednost in student.items():
    print(kljuc, vrijednost)

Također se koristi za zamjenu vrijednosti dviju varijabli bez pomoćne varijable:

a, b = 1, 2
a, b = b, a   # sad je a=2, b=1
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Set - kolekcija bez duplikata',
      content: '''
Set je kolekcija JEDINSTVENIH varijabli/vrijednosti (bez duplikata), bez definiranog redoslijeda:

brojevi = {1, 2, 2, 3, 3, 3}
print(brojevi)   # {1, 2, 3} - duplikati automatski uklonjeni

Set je koristan za brzo uklanjanje duplikata iz liste:

lista = [1, 2, 2, 3, 3, 3]
jedinstveni = list(set(lista))   # [1, 2, 3]

Kao i rječnik, set je implementiran preko hash tablice, pa je provjera "je li element u setu" (in) vrlo brza - puno brža nego provjera nad listom za velike kolekcije.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Operacije nad setovima',
      content: '''
Setovi podržavaju matematičke operacije nad skupovima:

a = {1, 2, 3}
b = {2, 3, 4}

a | b   # unija: {1, 2, 3, 4}
a & b   # presjek: {2, 3}
a - b   # razlika: {1}
a ^ b   # simetrična razlika: {1, 4}

Ove operacije su korisne za usporedbu dviju grupa podataka - pronalaženje zajedničkih varijabli (presjek) ili onih koje postoje samo u jednoj grupi (razlika).
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Usporedba struktura podataka',
      content: '''
Do sad smo upoznali 4 osnovne kolekcije varijabli u Pythonu:

list [1, 2, 3]      - uređena, mutable, dozvoljava duplikate
tuple (1, 2, 3)      - uređena, immutable, dozvoljava duplikate
dict {"a": 1}        - pristup preko ključa, mutable
set {1, 2, 3}        - bez duplikata, bez redoslijeda

Odabir strukture ovisi o pitanju: treba li mi redoslijed? Trebaju li mi duplikati? Hoću li mijenjati sadržaj? Pristupam li preko pozicije ili preko imena/ključa? Ovo je prirodni nastavak razumijevanja pojedinačnih varijabli - sad ih ORGANIZIRAŠ u smislene grupe.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb34s2q1',
      type: QuestionType.matching,
      prompt: 'Upari strukturu podataka s njenom ključnom osobinom.',
      matchPairs: {
        'tuple': 'Immutable, uređena kolekcija',
        'set': 'Bez duplikata, bez redoslijeda',
        'list': 'Mutable, uređena, dozvoljava duplikate',
        'dict': 'Pristup preko ključa, ne preko pozicije',
      },
    ),
    Question(
      id: 'vb34s2q2',
      type: QuestionType.matching,
      prompt: 'Upari operaciju nad setovima a={1,2,3}, b={2,3,4} s rezultatom.',
      matchPairs: {
        'a & b': '{2, 3}',
        'a | b': '{1, 2, 3, 4}',
        'a - b': '{1}',
        'a ^ b': '{1, 4}',
      },
    ),
    Question(
      id: 'vb34s2q3',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake uklanjanja duplikata iz liste pomoću seta.',
      hierarchyItems: [
        'Kreni od liste s duplikatima',
        'Pretvori listu u set pomoću set(lista)',
        'Set automatski uklanja duplikate',
        'Pretvori set natrag u listu pomoću list(set)',
      ],
    ),
    Question(
      id: 'vb34s2q4',
      type: QuestionType.matching,
      prompt: 'Upari situaciju s preporučenim tipom podataka.',
      matchPairs: {
        'Fiksne GPS koordinate koje se ne smiju mijenjati': 'tuple',
        'Popis jedinstvenih ID-eva bez duplikata': 'set',
        'Podaci o studentu s imenom i godinom': 'dict',
        'Redoslijed zadataka koje treba obaviti': 'list',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Napredne funkcije
// ---------------------------------------------------------------------

final LessonSection varB34S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: '*args - proizvoljan broj argumenata',
      content: '''
Ponekad ne znaš unaprijed koliko argumenata (varijabli) će funkcija primiti. *args omogućuje funkciji da prihvati bilo koji broj pozicijskih argumenata, koji se skupljaju u tuple:

def zbroji(*brojevi):
    return sum(brojevi)

print(zbroji(1, 2))          # 3
print(zbroji(1, 2, 3, 4))    # 10

Naziv args je konvencija, ali zvjezdica * je ta koja govori Pythonu da skupi sve argumente u tuple. Unutar funkcije, brojevi se ponaša kao običan tuple.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: '**kwargs - proizvoljan broj imenovanih argumenata',
      content: '''
Slično kao *args, ali za imenovane (keyword) argumente - skupljaju se u rječnik:

def ispisi_podatke(**podaci):
    for kljuc, vrijednost in podaci.items():
        print(f"{kljuc}: {vrijednost}")

ispisi_podatke(ime="Ana", godina=21, smjer="Strojarstvo")

*args i **kwargs se često koriste zajedno kad funkcija treba biti fleksibilna i primiti bilo koju kombinaciju varijabli - česta pojava u bibliotekama gdje se ne zna unaprijed što će korisnik proslijediti.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Lambda funkcije',
      content: '''
Lambda je kratka, anonimna funkcija definirana u jednoj liniji:

kvadrat = lambda x: x ** 2
print(kvadrat(5))   # 25

# Ekvivalentno klasičnoj funkciji:
def kvadrat(x):
    return x ** 2

Lambda se najčešće koristi kao argument drugim funkcijama, npr. kod sortiranja:

studenti = [{"ime": "Ana", "ocjena": 4}, {"ime": "Marko", "ocjena": 5}]
studenti.sort(key=lambda s: s["ocjena"])   # sortira po ocjeni
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'map, filter i list comprehension',
      content: '''
map() primjenjuje funkciju na SVAKU varijablu u kolekciji:

brojevi = [1, 2, 3, 4]
kvadrati = list(map(lambda x: x ** 2, brojevi))   # [1, 4, 9, 16]

filter() zadržava samo elemente koji zadovoljavaju uvjet:

parni = list(filter(lambda x: x % 2 == 0, brojevi))   # [2, 4]

List comprehension je kompaktniji, "pythonski" način pisanja istog:

kvadrati = [x ** 2 for x in brojevi]
parni = [x for x in brojevi if x % 2 == 0]
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Funkcije kao "objekti prvog reda"',
      content: '''
U Pythonu su funkcije "građani prvog reda" - to znači da se funkcija može tretirati kao bilo koja druga varijabla: spremiti u varijablu, proslijediti kao argument, ili vratiti iz funkcije.

def pozdravi():
    return "Bok!"

f = pozdravi        # spremamo funkciju (BEZ poziva) u varijablu
print(f())          # Bok! - pozivamo je preko f

def primijeni(funkcija, vrijednost):
    return funkcija(vrijednost)

print(primijeni(lambda x: x * 2, 5))   # 10

Ova fleksibilnost je temelj za napredne koncepte poput dekoratora i callback funkcija.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb34s3q1',
      type: QuestionType.matching,
      prompt: 'Upari sintaksu s njenom svrhom.',
      matchPairs: {
        '*args': 'Skuplja proizvoljan broj pozicijskih argumenata u tuple',
        '**kwargs': 'Skuplja proizvoljan broj imenovanih argumenata u rječnik',
        'lambda x: x**2': 'Kratka anonimna funkcija',
        '[x**2 for x in lista]': 'List comprehension',
      },
    ),
    Question(
      id: 'vb34s3q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake pretvaranja liste brojeva u listu kvadrata pomoću list comprehension.',
      hierarchyItems: [
        'Definiraj početnu listu brojeva',
        'Napiši izraz x ** 2 koji opisuje transformaciju',
        'Dodaj for x in brojevi da definiraš izvor elemenata',
        'Zatvori sve u uglate zagrade []',
      ],
    ),
    Question(
      id: 'vb34s3q3',
      type: QuestionType.matching,
      prompt: 'Upari funkciju s onim što radi nad brojevi = [1,2,3,4].',
      matchPairs: {
        'list(map(lambda x: x*2, brojevi))': '[2, 4, 6, 8]',
        'list(filter(lambda x: x > 2, brojevi))': '[3, 4]',
        '[x for x in brojevi if x % 2 == 0]': '[2, 4]',
        'sum(brojevi)': '10',
      },
    ),
    Question(
      id: 'vb34s3q4',
      type: QuestionType.matching,
      prompt: 'Upari pojam s objašnjenjem "funkcije kao objekt prvog reda".',
      matchPairs: {
        'f = pozdravi': 'Sprema funkciju u varijablu, bez poziva',
        'f()': 'Poziva funkciju spremljenu u varijabli f',
        'primijeni(funkcija, vrijednost)': 'Funkcija koja prima drugu funkciju kao argument',
        'return lambda x: x + 1': 'Funkcija koja vraća drugu funkciju',
      },
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Osnove OOP-a
// ---------------------------------------------------------------------

final LessonSection varB34S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Klase i objekti - varijable koje putuju zajedno',
      content: '''
Klasa je "nacrt" prema kojem se stvaraju objekti - grupira POVEZANE varijable (atribute) i funkcije koje nad njima djeluju:

class Student:
    def __init__(self, ime, godina):
        self.ime = ime
        self.godina = godina

s1 = Student("Ana", 3)
s2 = Student("Marko", 2)

print(s1.ime)   # Ana
print(s2.ime)   # Marko

__init__ je konstruktor koji postavlja početne vrijednosti atributa. self predstavlja sam objekt - preko njega objekt pristupa SVOJIM VLASTITIM varijablama (atributima), odvojenim od varijabli bilo kojeg drugog objekta iste klase.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Metode klase',
      content: '''
Osim atributa, klasa može imati i metode koje djeluju nad njenim varijablama:

class Student:
    def __init__(self, ime, ocjene):
        self.ime = ime
        self.ocjene = ocjene

    def prosjek(self):
        return sum(self.ocjene) / len(self.ocjene)

s1 = Student("Ana", [5, 4, 5])
print(s1.prosjek())   # 4.666...

Svaka metoda ima self kao prvi parametar - referenca na objekt preko kojeg je metoda pozvana, omogućuje pristup atributima TOG konkretnog objekta.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Nasljeđivanje',
      content: '''
Nasljeđivanje omogućuje da nova klasa (podklasa) preuzme varijable i metode postojeće klase (nadklase):

class Osoba:
    def __init__(self, ime):
        self.ime = ime

class Student(Osoba):
    def __init__(self, ime, smjer):
        super().__init__(ime)   # poziva konstruktor nadklase
        self.smjer = smjer

s = Student("Danijel", "Strojarstvo")
print(s.ime)     # Danijel (naslijeđeno od Osoba)
print(s.smjer)   # Strojarstvo (specifično za Student)

super() omogućuje pristup varijablama/metodama nadklase iz podklase, najčešće u konstruktoru da se ne duplicira kod.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Enkapsulacija atributa',
      content: '''
Python koristi konvenciju: prefiks donje crte označava da atribut NIJE namijenjen za direktan pristup izvana:

class BankovniRacun:
    def __init__(self, stanje):
        self._stanje = stanje

    def podigni(self, iznos):
        if iznos <= self._stanje:
            self._stanje -= iznos

    def get_stanje(self):
        return self._stanje

Ideja enkapsulacije je da se pristup varijablama kontrolira kroz metode, umjesto direktnog mijenjanja atributa izvana - sprječava se postavljanje nevažećih vrijednosti.
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - od varijable do objekta',
      content: '''
Ova lekcija pokazala je put od pojedinačne varijable do organiziranih struktura:

1. Rječnik grupira varijable pod smislenim imenima (ključevima)
2. Tuple i set nude specijalizirane kolekcije (nepromjenjive, bez duplikata)
3. Funkcije s *args/**kwargs prihvaćaju proizvoljan broj varijabli
4. Klase grupiraju POVEZANE varijable (atribute) i logiku koja nad njima djeluje

Ovo je prirodna nadogradnja na Bloom 1-2 razinu (pojedinačna varijabla u memoriji) - sad znaš ORGANIZIRATI mnogo varijabli u smislene, upravljive cjeline. U idućoj razini (Bloom 5-6) naučit ćeš pisati kompletne programe koji koriste sve ove strukture.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb34s4q1',
      type: QuestionType.matching,
      prompt: 'Upari OOP pojam s njegovim značenjem.',
      matchPairs: {
        'klasa': 'Nacrt/predložak prema kojem se stvaraju objekti',
        'objekt': 'Konkretna instanca klase',
        '__init__': 'Konstruktor - postavlja početne vrijednosti',
        'self': 'Referenca na trenutni objekt unutar metode',
      },
    ),
    Question(
      id: 'vb34s4q2',
      type: QuestionType.hierarchy,
      prompt: 'Poredaj korake stvaranja objekta klase Student("Ana", 3).',
      hierarchyItems: [
        'Python pronalazi definiciju klase Student',
        'Poziva se __init__ metoda',
        'self se automatski povezuje s novim objektom',
        'Parametri se spremaju kao atributi self.ime i self.godina',
      ],
    ),
    Question(
      id: 'vb34s4q3',
      type: QuestionType.matching,
      prompt: 'Upari koncept nasljeđivanja s primjerom: class Student(Osoba).',
      matchPairs: {
        'Osoba': 'Nadklasa (roditeljska klasa)',
        'Student': 'Podklasa (nasljeđuje od Osoba)',
        'super().__init__(ime)': 'Poziva konstruktor nadklase',
        's.ime': 'Naslijeđeni atribut, dostupan i u Student',
      },
    ),
    Question(
      id: 'vb34s4q4',
      type: QuestionType.matching,
      prompt: 'Upari prednost organizacije varijabli s objašnjenjem.',
      matchPairs: {
        'Rječnik': 'Grupira varijable pod smislenim ključevima',
        'Klasa': 'Grupira POVEZANE varijable i logiku zajedno',
        'Enkapsulacija': 'Kontrola pristupa varijablama kroz metode',
        '*args': 'Prihvaća proizvoljan broj varijabli u funkciju',
      },
    ),
  ],
);

final Lesson varijableBloom34 = Lesson(
  id: 102,
  title: 'Varijable - Strukture podataka i OOP',
  bloomLevels: '3-4',
  questionType: QuestionType.matching,
  sections: [varB34S1, varB34S2, varB34S3, varB34S4],
);