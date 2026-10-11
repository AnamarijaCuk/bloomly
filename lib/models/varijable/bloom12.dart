// lib/models/varijable/bloom12.dart
//
// Tema VARIJABLE — Bloom 1-2 (Pamćenje/Razumijevanje)
// Osnovno objašnjenje varijabli i memorije. Objektivna pitanja.

import '../lesson_model.dart';

final LessonSection varB12S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Što je varijabla?',
      content: '''
Varijabla je naziv koji koristimo da bismo se referirali na neki podatak spremljen u memoriji računala. Zamisli je kao naljepnicu zalijepljenu na kutiju - naljepnica (naziv varijable) ti govori što je unutra, a kutija (memorija) fizički čuva sadržaj.

U Pythonu, varijablu stvaraš jednostavnim dodjeljivanjem vrijednosti:

x = 5
ime = "Ana"
temperatura = 21.5

Za razliku od nekih drugih jezika (npr. C++), u Pythonu ne moraš unaprijed reći koje vrste podatka će varijabla sadržavati - Python to sam prepoznaje u trenutku dodjeljivanja. Ovo se zove dinamičko tipiziranje.
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Gdje se varijabla nalazi u memoriji?',
      content: '''
Kada napišeš x = 5, dogodi se sljedeće:
1. Python u memoriji (RAM-u) stvori objekt koji predstavlja broj 5.
2. Taj objekt dobije svoju memorijsku adresu (mjesto u RAM-u).
3. Naziv "x" postane referenca (pokazivač) koji upućuje na tu adresu.

Bitno je razumjeti: varijabla x nije sama kutija s podatkom - ona je etiketa koja pokazuje na kutiju. Više naziva može pokazivati na isti podatak u memoriji.

Ovo možeš provjeriti u Pythonu naredbom id(x), koja vraća memorijsku adresu objekta na koji x trenutno pokazuje.
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Pravila imenovanja varijabli',
      content: '''
Nazivi varijabli u Pythonu moraju slijediti određena pravila:

- Smiju sadržavati slova, brojeve i donju crtu _
- NE SMIJU počinjati brojem (1x = 5 je greška)
- Osjetljivi su na velika/mala slova (ime i Ime su DVIJE različite varijable)
- Ne smiju biti rezervirane riječi Pythona (for, if, class, itd.)

Konvencija (PEP 8, službeni stil pisanja Pythona) preporučuje snake_case za varijable:

broj_studenata = 30
prosjecna_ocjena = 4.2

Iako Python dopušta i camelCase (brojStudenata), snake_case je standard u Python zajednici, za razliku od npr. Jave ili Darta gdje je camelCase uobičajen.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Dodjeljivanje više varijabli odjednom',
      content: '''
Python omogućuje dodjeljivanje više varijabli u jednom retku:

x, y, z = 1, 2, 3

Sve tri varijable dobiju svoju vrijednost odjednom - x=1, y=2, z=3. Broj varijabli lijevo mora odgovarati broju vrijednosti desno, inače Python baca grešku.

Također možeš dodijeliti ISTU vrijednost više varijabli odjednom:

a = b = c = 0

Ovdje sve tri varijable (a, b, c) pokazuju na ISTI objekt u memoriji (broj 0) - nisu to tri odvojena mjesta u memoriji, nego tri naziva koja pokazuju na jedno te isto mjesto.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Promjena vrijednosti varijable',
      content: '''
Kad "promijeniš" vrijednost varijable u Pythonu, zapravo se ne mijenja stari objekt u memoriji - stvara se novi objekt, a varijabla (naziv) samo počne pokazivati na taj novi objekt.

x = 5      # x pokazuje na objekt "5" u memoriji
x = 10     # stvoren je NOVI objekt "10", x sad pokazuje na njega
           # stari objekt "5" ostaje u memoriji dok ga
           # Python "garbage collector" ne obriše (ako ništa drugo ne pokazuje na njega)

Ova ideja - da promjena varijable zapravo znači "preusmjeri naljepnicu na novu kutiju", umjesto "promijeni sadržaj iste kutije" - ključna je za razumijevanje kako Python radi s memorijom, i vraćat ćemo joj se kroz cijelu ovu lekciju.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb12s1q1',
      type: QuestionType.objective,
      prompt: 'Što se događa kad napišeš x = 5 u Pythonu?',
      options: [
        'Python rezervira 4 bajta memorije za broj 5',
        'Python stvori objekt za broj 5 u memoriji, a x postane referenca na njega',
        'Broj 5 se sprema direktno unutar naziva varijable x',
        'Ništa se ne sprema dok se varijabla ne koristi',
      ],
      correctAnswer: 'Python stvori objekt za broj 5 u memoriji, a x postane referenca na njega',
    ),
    Question(
      id: 'vb12s1q2',
      type: QuestionType.objective,
      prompt: 'Koji naziv varijable je NEISPRAVAN u Pythonu?',
      options: ['broj_1', '_privatno', '1broj', 'brojStudenata'],
      correctAnswer: '1broj',
    ),
    Question(
      id: 'vb12s1q3',
      type: QuestionType.objective,
      prompt: 'Nakon naredbe a = b = c = 0, što je istina?',
      options: [
        'a, b i c su tri odvojena mjesta u memoriji s vrijednošću 0',
        'a, b i c pokazuju na isti objekt (broj 0) u memoriji',
        'Samo c ima vrijednost 0, a i b su None',
        'Ovo je sintaksna greška',
      ],
      correctAnswer: 'a, b i c pokazuju na isti objekt (broj 0) u memoriji',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Tipovi podataka i memorija
// ---------------------------------------------------------------------

final LessonSection varB12S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Osnovni tipovi podataka',
      content: '''
Python ima nekoliko osnovnih (ugrađenih) tipova podataka:

- int - cijeli brojevi (npr. 5, -12, 1000)
- float - decimalni brojevi (npr. 3.14, -0.5)
- str - tekst, niz znakova (npr. "Split", 'strojarstvo')
- bool - logička vrijednost, True ili False
- NoneType - posebna vrijednost None, označava "nema vrijednosti"

Tip varijable možeš provjeriti funkcijom type():

x = 5
print(type(x))   # <class 'int'>

y = 3.14
print(type(y))   # <class 'float'>

Svaki od ovih tipova zauzima drugačiju količinu memorije i sprema se na drugačiji način - o tome više na sljedećim stranicama.
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Koliko memorije zauzima varijabla?',
      content: '''
Svaki podatak u memoriji zauzima određeni broj bajtova. U Pythonu možeš provjeriti veličinu objekta pomoću sys.getsizeof():

import sys
x = 5
print(sys.getsizeof(x))   # npr. 28 bajtova

Ovo je veće nego što bi očekivao za "obični" cijeli broj (u C-u je int obično 4 bajta) - razlog je taj što Python svaki broj sprema kao pravi objekt, s dodatnim metapodacima (tip, broj referenci na njega, itd.), ne kao "goli" broj u memoriji.

Ovo je kompromis: Python je fleksibilniji i sigurniji za rad, ali troši više memorije i sporiji je od jezika poput C-a ili C++-a, koji rade direktnije s memorijom.
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Cijeli brojevi (int) - posebnost Pythona',
      content: '''
Za razliku od većine jezika, Python int NEMA fiksnu veličinu (npr. 32-bit ili 64-bit) - može predstavljati proizvoljno velike brojeve, ograničene samo dostupnom memorijom:

veliki_broj = 10 ** 100   # broj sa 101 znamenkom - radi bez problema!
print(veliki_broj)

U jezicima poput C-a, ovakav izračun bi uzrokovao overflow (prelijevanje) jer int ima fiksnu veličinu. Python interno automatski prelazi na veći memorijski zapis kad broj postane prevelik za standardni format - ovo se zove "arbitrary precision" (proizvoljna preciznost) i jedan je od razloga zašto je Python popularan u znanstvenim i inženjerskim izračunima.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Decimalni brojevi (float) i preciznost',
      content: '''
float u Pythonu sprema decimalne brojeve prema IEEE 754 standardu (isti standard kao u većini programskih jezika), koristeći 64 bita (8 bajtova) memorije.

Zbog načina na koji se decimalni brojevi spremaju u binarnom obliku, mogu se pojaviti sitne greške zaokruživanja:

print(0.1 + 0.2)   # 0.30000000000000004, ne točno 0.3!

Ovo NIJE greška u Pythonu, nego posljedica toga kako se decimalni brojevi fizički spremaju u memoriji - isti problem postoji u gotovo svim programskim jezicima. Kod inženjerskih izračuna gdje je preciznost bitna, koristi se modul decimal ili se rezultati zaokružuju pomoću round().
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Pretvorba tipova (type casting)',
      content: '''
Ponekad trebaš pretvoriti podatak iz jednog tipa u drugi - ovo se zove type casting, i uvijek stvara NOVI objekt u memoriji (originalna varijabla ostaje nepromijenjena):

broj_kao_tekst = "42"
broj = int(broj_kao_tekst)     # pretvara string u int -> 42
decimalni = float(broj)         # pretvara int u float -> 42.0
natrag_u_tekst = str(decimalni) # pretvara float u string -> "42.0"

Ako pokušaš pretvoriti nešto što nije valjan broj, Python baca grešku:

int("abc")   # ValueError: invalid literal for int()

Ova pretvorba je česta kod čitanja korisničkog unosa - input() u Pythonu UVIJEK vraća string, pa ako trebaš broj, moraš eksplicitno pretvoriti.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb12s2q1',
      type: QuestionType.objective,
      prompt: 'Zašto sys.getsizeof(5) vraća više od 4 bajta (koliko zauzima "goli" int u C-u)?',
      options: [
        'Python čuva broj kao tekst, ne kao broj',
        'Python objekt uz vrijednost sprema i dodatne metapodatke (tip, broj referenci...)',
        'To je greška u mjerenju',
        'Python uvijek rezervira dodatnih 24 bajta za buduće varijable',
      ],
      correctAnswer: 'Python objekt uz vrijednost sprema i dodatne metapodatke (tip, broj referenci...)',
    ),
    Question(
      id: 'vb12s2q2',
      type: QuestionType.objective,
      prompt: 'Zašto Python int može predstavljati proizvoljno velike brojeve, za razliku od C-a?',
      options: [
        'Python koristi float za sve brojeve',
        'Python int nema fiksnu veličinu - automatski se proširuje po potrebi',
        'Python zaokružuje velike brojeve',
        'To nije istina, i Python ima ograničenje',
      ],
      correctAnswer: 'Python int nema fiksnu veličinu - automatski se proširuje po potrebi',
    ),
    Question(
      id: 'vb12s2q3',
      type: QuestionType.objective,
      prompt: 'Zašto 0.1 + 0.2 u Pythonu ne daje točno 0.3?',
      options: [
        'Python ima grešku u zbrajanju',
        'Decimalni brojevi se u binarnom obliku ne mogu uvijek točno zapisati',
        'Treba koristiti zarez umjesto točke',
        '0.1 i 0.2 su stringovi, ne brojevi',
      ],
      correctAnswer: 'Decimalni brojevi se u binarnom obliku ne mogu uvijek točno zapisati',
    ),
    Question(
      id: 'vb12s2q4',
      type: QuestionType.objective,
      prompt: 'Što vraća funkcija input() u Pythonu, bez obzira što korisnik upiše?',
      options: ['int', 'float', 'str', 'bool'],
      correctAnswer: 'str',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Referentna memorija, mutabilnost
// ---------------------------------------------------------------------

final LessonSection varB12S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Immutable tipovi - "nepromjenjivi" objekti',
      content: '''
int, float, str i bool su immutable (nepromjenjivi) tipovi - jednom stvoren objekt tog tipa NIKAD se ne mijenja. Svaka "promjena" zapravo stvara potpuno novi objekt:

x = 5
print(id(x))   # npr. 140712834567296
x = x + 1
print(id(x))   # DRUGA adresa! Stvoren je novi objekt za broj 6

Ovo vrijedi i za stringove:

tekst = "Split"
tekst = tekst + " je lijep"   # stvara se NOVI string, stari "Split" ostaje u memoriji
                                # (dok ga garbage collector ne obriše)

Zbog ovoga, često spajanje mnogo stringova u petlji (tekst += nesto) je sporo za velike količine teksta - svaki + stvara novi objekt u memoriji.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Dvije varijable, isti objekt',
      content: '''
Kad dodijeliš jednu varijablu drugoj (b = a), NE stvara se kopija podatka - obje varijable počnu pokazivati na ISTI objekt u memoriji:

a = 100
b = a
print(id(a) == id(b))   # True - isti objekt!

Za immutable tipove (kao int) ovo nema vidljivih posljedica, jer se ionako ne mogu mijenjati - ako promijeniš a, jednostavno se a preusmjeri na novi objekt, a b i dalje pokazuje na stari:

a = 100
b = a
a = 200
print(b)   # i dalje 100 - b nije "pratio" a

Ovo se bitno razlikuje kod mutable tipova (npr. lista), gdje promjena kroz jednu varijablu utječe i na drugu - o tome detaljnije u sljedećoj lekciji o listama.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Usporedba vrijednosti vs usporedba identiteta',
      content: '''
Python razlikuje dva načina usporedbe:

== provjerava JESU LI VRIJEDNOSTI jednake
is provjerava POKAZUJU LI OBJE VARIJABLE NA ISTI OBJEKT u memoriji

x = 1000
y = 1000
print(x == y)   # True - vrijednosti su jednake
print(x is y)   # Često False - to su DVA različita objekta s istom vrijednošću!

Zanimljivost: za MALE cijele brojeve (od -5 do 256), Python interno "cacheira" (unaprijed stvara i ponovno koristi) objekte radi uštede memorije, pa je is za njih često True:

a = 5
b = 5
print(a is b)   # True - Python koristi isti "cache-irani" objekt za broj 5

Ovo je interna optimizacija Pythona i ne bi se trebala koristiti kao pouzdano pravilo u kodu - za usporedbu vrijednosti UVIJEK koristi ==, ne is.
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Garbage collection - čišćenje memorije',
      content: '''
Kad objekt u memoriji više NEMA nijednu varijablu (referencu) koja na njega pokazuje, Python ga automatski uklanja iz memorije - ovo se zove garbage collection (skupljanje smeća).

x = [1, 2, 3]   # lista stvorena u memoriji, x pokazuje na nju
x = None        # x sad pokazuje na None - stara lista [1,2,3] nema više referenci
                # Python je automatski oslobađa iz memorije

Python broji koliko referenci pokazuje na svaki objekt (reference counting). Kad taj broj padne na 0, memorija se automatski oslobađa - programer NE MORA ručno brisati objekte iz memorije (za razliku od jezika poput C-a, gdje se memorija mora ručno oslobađati pomoću free()).

Ovo čini Python sigurnijim za rad (manje grešaka vezanih uz memoriju), ali dodaje mali overhead u odnosu na jezike s ručnim upravljanjem memorijom.
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Stog (stack) i hrpa (heap) - gdje što živi',
      content: '''
U većini programskih jezika (uključujući Python "ispod haube"), memorija programa dijeli se na dva glavna dijela:

STOG (stack) - brza, organizirana memorija gdje se čuvaju lokalne varijable i pozivi funkcija. Kad funkcija završi, njen dio stoga se automatski oslobađa.

HRPA (heap) - veća, fleksibilnija memorija gdje se čuvaju stvarni objekti (brojevi, stringovi, liste...). Varijable na stogu zapravo sadrže REFERENCE (adrese) prema objektima na hrpi.

def izracunaj():
    x = 5   # naziv "x" je na stogu, ALI sam objekt "5" je na hrpi
    return x

Ovo objašnjava zašto je moguće da više varijabli (na različitim mjestima u kodu) dijeli isti objekt u memoriji - sve one samo sadrže referencu prema istom mjestu na hrpi.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb12s3q1',
      type: QuestionType.objective,
      prompt: 'Nakon x = 5; x = x + 1, što se dogodilo u memoriji?',
      options: [
        'Broj 5 je promijenjen u 6 na istom mjestu',
        'Stvoren je novi objekt za broj 6, x sad pokazuje na njega',
        'x sada pokazuje na dva objekta odjednom',
        'Ništa, x i dalje pokazuje na 5',
      ],
      correctAnswer: 'Stvoren je novi objekt za broj 6, x sad pokazuje na njega',
    ),
    Question(
      id: 'vb12s3q2',
      type: QuestionType.objective,
      prompt: 'Koji operator provjerava pokazuju li dvije varijable na ISTI objekt u memoriji?',
      options: ['==', 'is', 'equals()', '==='],
      correctAnswer: 'is',
    ),
    Question(
      id: 'vb12s3q3',
      type: QuestionType.objective,
      prompt: 'Što se dogodi kad objekt u memoriji izgubi SVE reference (nijedna varijabla više ne pokazuje na njega)?',
      options: [
        'Program se ruši',
        'Python ga automatski oslobađa iz memorije (garbage collection)',
        'Objekt ostaje zauvijek u memoriji',
        'Python baca grešku upozorenja',
      ],
      correctAnswer: 'Python ga automatski oslobađa iz memorije (garbage collection)',
    ),
    Question(
      id: 'vb12s3q4',
      type: QuestionType.objective,
      prompt: 'Gdje se u memoriji nalazi stvarni sadržaj objekta (npr. broj ili string), dok stog sadrži samo referencu na njega?',
      options: ['Registar procesora', 'Hrpa (heap)', 'Cache memorija', 'ROM'],
      correctAnswer: 'Hrpa (heap)',
    ),
    Question(
      id: 'vb12s3q5',
      type: QuestionType.objective,
      prompt: 'Nakon a = 100; b = a; a = 200 - koja je vrijednost varijable b?',
      options: ['100', '200', 'None', 'Greška'],
      correctAnswer: '100',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Doseg varijabli i pregled
// ---------------------------------------------------------------------

final LessonSection varB12S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Lokalne varijable',
      content: '''
Varijabla definirana UNUTAR funkcije je lokalna - postoji samo dok se funkcija izvršava, i njen prostor u memoriji (na stogu) automatski se oslobađa čim funkcija završi:

def izracunaj():
    rezultat = 10 * 2   # lokalna varijabla
    return rezultat

print(izracunaj())   # 20
print(rezultat)       # GREŠKA! rezultat ne postoji izvan funkcije

Svaki poziv funkcije dobiva svoj VLASTITI prostor za lokalne varijable na stogu - ako pozoveš istu funkciju dva puta, svaki poziv ima svoju zasebnu kopiju lokalnih varijabli, čak i ako se zovu isto.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Globalne varijable',
      content: '''
Varijabla definirana IZVAN svih funkcija je globalna - vidljiva je unutar funkcija (za čitanje), i živi u memoriji sve dok program radi:

BROJ_STUDENATA = 30   # globalna varijabla

def ispisi():
    print(BROJ_STUDENATA)   # čitanje globalne varijable radi bez problema

ispisi()   # 30

Ali ako želiš MIJENJATI globalnu varijablu unutar funkcije, moraš eksplicitno koristiti global:

brojac = 0
def povecaj():
    global brojac
    brojac += 1

Bez global, Python bi unutar funkcije stvorio NOVU lokalnu varijablu istog imena, umjesto da mijenja globalnu - originalna globalna varijabla ostala bi nepromijenjena.
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Konstante - konvencija, ne pravilo',
      content: '''
Python nema pravu podršku za konstante (vrijednosti koje se ne mogu mijenjati nakon definiranja) - umjesto toga, koristi se KONVENCIJA: varijable pisane VELIKIM SLOVIMA smatraju se konstantama, iako ih tehnički i dalje možeš promijeniti:

PI = 3.14159
MAX_POKUSAJA = 3
NAZIV_APLIKACIJE = "Bloomly"

Python neće spriječiti PI = 4 - to je samo signal drugim programerima (i tebi samom) da se ta vrijednost ne bi trebala mijenjati tijekom izvođenja programa. Za razliku od nekih jezika (npr. const u C++/JavaScript), Python se ovdje oslanja na dogovor, ne na jezičnu prisilu.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'None - odsutnost vrijednosti',
      content: '''
None je posebna vrijednost u Pythonu koja predstavlja "nema vrijednosti" ili "prazno". Ima svoj vlastiti tip, NoneType, i u memoriji postoji samo JEDAN None objekt tijekom cijelog izvođenja programa - sve varijable postavljene na None pokazuju na isti taj objekt:

x = None
y = None
print(x is y)   # True - oba pokazuju na jedini None objekt

None se često koristi kao:
- Zadana (default) vrijednost parametra funkcije
- Signal da funkcija "nije pronašla" rezultat
- Početna vrijednost varijable prije nego dobije stvarni podatak

Provjera je li nešto None radi se preko is, ne ==:

if x is None:
    print("x nema vrijednost")
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - put jedne varijable kroz memoriju',
      content: '''
Prošli smo cijeli životni ciklus varijable u Pythonu. Sažetak ključnih ideja:

1. Varijabla je NAZIV (referenca), ne sama kutija - podatak živi odvojeno, na hrpi (heap)
2. int, float, str, bool su immutable - svaka "promjena" stvara NOVI objekt
3. Više varijabli može pokazivati na ISTI objekt (b = a ne kopira podatak)
4. == uspoređuje vrijednosti, is uspoređuje identitet (isti objekt u memoriji)
5. Garbage collector automatski čisti objekte bez ijedne reference
6. Lokalne varijable žive na stogu dok funkcija traje; globalne žive dok program radi

Ovo razumijevanje memorije temelj je za sve što slijedi - u idućoj lekciji učiš o listama, koje su MUTABLE (za razliku od svega što smo dosad vidjeli), pa će se ponašanje u memoriji značajno razlikovati.
''',
    ),
  ],
  questions: [
    Question(
      id: 'vb12s4q1',
      type: QuestionType.objective,
      prompt: 'Što se dogodi s lokalnom varijablom kad funkcija u kojoj je definirana završi?',
      options: [
        'Ostaje dostupna izvan funkcije',
        'Njen prostor na stogu se automatski oslobađa',
        'Pretvara se u globalnu varijablu',
        'Baca grešku',
      ],
      correctAnswer: 'Njen prostor na stogu se automatski oslobađa',
    ),
    Question(
      id: 'vb12s4q2',
      type: QuestionType.objective,
      prompt: 'Zašto je unutar funkcije potrebna ključna riječ global da bi se promijenila globalna varijabla?',
      options: [
        'Nije potrebna, Python to radi automatski',
        'Bez nje bi Python stvorio novu lokalnu varijablu istog imena',
        'global ubrzava izvođenje',
        'Potrebna je samo za brojeve',
      ],
      correctAnswer: 'Bez nje bi Python stvorio novu lokalnu varijablu istog imena',
    ),
    Question(
      id: 'vb12s4q3',
      type: QuestionType.objective,
      prompt: 'Kako Python "označava" konstante, s obzirom da nema pravu jezičnu podršku za njih?',
      options: [
        'Ključnom riječi const',
        'Konvencijom - pisanjem naziva VELIKIM SLOVIMA',
        'Posebnim tipom Constant',
        'Python uopće ne podržava koncept konstanti',
      ],
      correctAnswer: 'Konvencijom - pisanjem naziva VELIKIM SLOVIMA',
    ),
    Question(
      id: 'vb12s4q4',
      type: QuestionType.objective,
      prompt: 'Koliko None objekata postoji u memoriji tijekom izvođenja Python programa?',
      options: ['Jedan po varijabli', 'Samo jedan, dijele ga sve varijable', 'Nula, None nije objekt', 'Ovisi o broju funkcija'],
      correctAnswer: 'Samo jedan, dijele ga sve varijable',
    ),
    Question(
      id: 'vb12s4q5',
      type: QuestionType.objective,
      prompt: 'Kojim operatorom se ispravno provjerava je li varijabla None?',
      options: ['x == None', 'x is None', 'x = None', 'x equals None'],
      correctAnswer: 'x is None',
    ),
    Question(
      id: 'vb12s4q6',
      type: QuestionType.objective,
      prompt: 'Gdje žive globalne varijable, u odnosu na trajanje programa?',
      options: [
        'Samo dok se jedna funkcija izvršava',
        'Dok program radi, od pokretanja do kraja',
        'Samo unutar main() funkcije',
        'Brišu se nakon svakog poziva funkcije',
      ],
      correctAnswer: 'Dok program radi, od pokretanja do kraja',
    ),
  ],
);

final Lesson varijableBloom12 = Lesson(
  id: 101,
  title: 'Varijable - Osnove',
  bloomLevels: '1-2',
  questionType: QuestionType.objective,
  sections: [varB12S1, varB12S2, varB12S3, varB12S4],
);