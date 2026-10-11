// lib/models/liste/bloom56.dart
//
// Tema LISTE — Bloom 5-6 (Evaluacija/Kreiranje)
// Pisanje algoritama koji rade nad listama. Pitanja: pisanje/izvršavanje koda.

import '../lesson_model.dart';

// ---------------------------------------------------------------------
// Sekcija 1 (stranice 1-5) — Algoritmi sortiranja
// ---------------------------------------------------------------------

final LessonSection listB56S1 = LessonSection(
  sectionIndex: 0,
  pages: [
    LessonPage(
      pageNumber: 1,
      title: 'Bubble sort - sortiranje mjehurićem',
      content: '''
Bubble sort ponavljano prolazi kroz listu, uspoređuje SUSJEDNE elemente i zamjenjuje ih ako su u pogrešnom redoslijedu:

def bubble_sort(lista):
    n = len(lista)
    for i in range(n):
        for j in range(n - i - 1):
            if lista[j] > lista[j + 1]:
                lista[j], lista[j + 1] = lista[j + 1], lista[j]
    return lista

print(bubble_sort([5, 2, 8, 1, 9]))   # [1, 2, 5, 8, 9]

Naziv "bubble" (mjehurić) dolazi otud što se veći elementi postupno "izdižu" prema kraju liste, poput mjehurića u vodi. Jednostavan za razumjeti, ali spor za velike liste (O(n²)).
''',
    ),
    LessonPage(
      pageNumber: 2,
      title: 'Selection sort - sortiranje odabirom',
      content: '''
Selection sort u svakom prolazu pronalazi NAJMANJI element preostale liste i stavlja ga na svoje mjesto:

def selection_sort(lista):
    n = len(lista)
    for i in range(n):
        min_indeks = i
        for j in range(i + 1, n):
            if lista[j] < lista[min_indeks]:
                min_indeks = j
        lista[i], lista[min_indeks] = lista[min_indeks], lista[i]
    return lista

print(selection_sort([5, 2, 8, 1, 9]))   # [1, 2, 5, 8, 9]

Za razliku od bubble sorta, selection sort radi MANJE zamjena (samo jednu po prolazu), iako i dalje ima istu vremensku složenost O(n²).
''',
    ),
    LessonPage(
      pageNumber: 3,
      title: 'Insertion sort - sortiranje umetanjem',
      content: '''
Insertion sort gradi sortirani dio liste postupno, umećući svaki sljedeći element na ispravno mjesto:

def insertion_sort(lista):
    for i in range(1, len(lista)):
        kljuc = lista[i]
        j = i - 1
        while j >= 0 and lista[j] > kljuc:
            lista[j + 1] = lista[j]
            j -= 1
        lista[j + 1] = kljuc
    return lista

print(insertion_sort([5, 2, 8, 1, 9]))   # [1, 2, 5, 8, 9]

Insertion sort je efikasan za MALE liste ili liste koje su već gotovo sortirane - u tim slučajevima se približava linearnoj brzini.
''',
    ),
    LessonPage(
      pageNumber: 4,
      title: 'Zamjena vrijednosti (swap) - obrazac u svim algoritmima',
      content: '''
Svi algoritmi sortiranja koriste isti obrazac za zamjenu dva elementa - Python ovo omogućuje elegantno, bez pomoćne varijable:

lista = [1, 2, 3]
lista[0], lista[2] = lista[2], lista[0]
print(lista)   # [3, 2, 1]

U jezicima poput C-a, ovo bi zahtijevalo pomoćnu varijablu:

temp = lista[0]
lista[0] = lista[2]
lista[2] = temp

Python izračuna DESNU stranu (lista[2], lista[0]) kao tuple PRIJE dodjele, pa je zamjena atomska i ne zahtijeva pomoćnu varijablu.
''',
    ),
    LessonPage(
      pageNumber: 5,
      title: 'Usporedba algoritama sortiranja',
      content: '''
Sva tri algoritma koja smo napisali (bubble, selection, insertion sort) imaju vremensku složenost O(n²) - za listu od n elemenata, u najgorem slučaju izvode otprilike n² usporedbi.

Ugrađeni sorted()/list.sort() u Pythonu koristi Timsort, puno naprednija implementacija koja u praksi postiže O(n log n) - zato se u stvarnom kodu UVIJEK koristi sorted()/sort(), a ručno pisani algoritmi služe za razumijevanje principa i vježbu algoritamskog razmišljanja.

Ipak, razumijevanje ovih osnovnih algoritama je temelj za analizu složenijih algoritama koje ćeš sretati u kolegijima poput "Algoritmi i strukture podataka".
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb56s1q1',
      type: QuestionType.code,
      prompt: 'Napiši bubble sort funkciju i sortiraj listu [4, 2, 7, 1, 3].',
      codeTaskPrompt: 'def bubble_sort(lista):\n    n = len(lista)\n    for i in range(n):\n        for j in range(n - i - 1):\n            if lista[j] > lista[j + 1]:\n                lista[j], lista[j + 1] = lista[j + 1], lista[j]\n    return lista\n\nprint(bubble_sort([4, 2, 7, 1, 3]))',
      expectedOutput: '[1, 2, 3, 4, 7]',
    ),
    Question(
      id: 'lb56s1q2',
      type: QuestionType.code,
      prompt: 'Napiši selection sort funkciju i sortiraj listu [6, 3, 8, 2].',
      codeTaskPrompt: 'def selection_sort(lista):\n    n = len(lista)\n    for i in range(n):\n        min_indeks = i\n        for j in range(i + 1, n):\n            if lista[j] < lista[min_indeks]:\n                min_indeks = j\n        lista[i], lista[min_indeks] = lista[min_indeks], lista[i]\n    return lista\n\nprint(selection_sort([6, 3, 8, 2]))',
      expectedOutput: '[2, 3, 6, 8]',
    ),
    Question(
      id: 'lb56s1q3',
      type: QuestionType.code,
      prompt: 'Napiši insertion sort funkciju i sortiraj listu [9, 1, 4, 2].',
      codeTaskPrompt: 'def insertion_sort(lista):\n    for i in range(1, len(lista)):\n        kljuc = lista[i]\n        j = i - 1\n        while j >= 0 and lista[j] > kljuc:\n            lista[j + 1] = lista[j]\n            j -= 1\n        lista[j + 1] = kljuc\n    return lista\n\nprint(insertion_sort([9, 1, 4, 2]))',
      expectedOutput: '[1, 2, 4, 9]',
    ),
    Question(
      id: 'lb56s1q4',
      type: QuestionType.code,
      prompt: 'Napiši kod koji zamijeni prvi i zadnji element liste [1, 2, 3, 4] bez pomoćne varijable.',
      codeTaskPrompt: 'lista = [1, 2, 3, 4]\nlista[0], lista[-1] = lista[-1], lista[0]\nprint(lista)',
      expectedOutput: '[4, 2, 3, 1]',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 2 (stranice 6-10) — Algoritmi pretrage
// ---------------------------------------------------------------------

final LessonSection listB56S2 = LessonSection(
  sectionIndex: 1,
  pages: [
    LessonPage(
      pageNumber: 6,
      title: 'Linearna pretraga',
      content: '''
Linearna pretraga prolazi kroz SVAKI element liste dok ne pronađe traženi (ili dok ne dođe do kraja):

def linearna_pretraga(lista, trazeni):
    for i, element in enumerate(lista):
        if element == trazeni:
            return i
    return -1

print(linearna_pretraga([4, 8, 15, 16, 23], 16))   # 3
print(linearna_pretraga([4, 8, 15, 16, 23], 99))   # -1

Radi na BILO KOJOJ listi (sortiranoj ili ne), ali u najgorem slučaju mora provjeriti SVE elemente - vremenska složenost O(n).
''',
    ),
    LessonPage(
      pageNumber: 7,
      title: 'Binarna pretraga - preduvjet: sortirana lista',
      content: '''
Binarna pretraga je puno brža, ali zahtijeva da je lista VEĆ SORTIRANA. Svaki korak prepolovi prostor pretrage:

def binarna_pretraga(lista, trazeni):
    lijevo, desno = 0, len(lista) - 1
    while lijevo <= desno:
        sredina = (lijevo + desno) // 2
        if lista[sredina] == trazeni:
            return sredina
        elif lista[sredina] < trazeni:
            lijevo = sredina + 1
        else:
            desno = sredina - 1
    return -1

print(binarna_pretraga([1, 3, 5, 7, 9, 11], 7))   # 3

Umjesto provjere SVAKOG elementa, binarna pretraga "odbacuje" polovicu preostale liste u svakom koraku - vremenska složenost O(log n), znatno brže od linearne za velike liste.
''',
    ),
    LessonPage(
      pageNumber: 8,
      title: 'Pronalaženje svih pojavljivanja',
      content: '''
Za razliku od pronalaska JEDNOG pojavljivanja, ponekad trebaš SVE indekse gdje se element pojavljuje:

def sva_pojavljivanja(lista, trazeni):
    indeksi = []
    for i, element in enumerate(lista):
        if element == trazeni:
            indeksi.append(i)
    return indeksi

print(sva_pojavljivanja([1, 3, 3, 5, 3, 7], 3))   # [1, 2, 4]

Ovo je varijacija linearne pretrage - umjesto ranog return-a čim se element pronađe, nastavljamo do kraja liste i SKUPLJAMO sve podudarne indekse.
''',
    ),
    LessonPage(
      pageNumber: 9,
      title: 'Pronalaženje drugog najvećeg elementa',
      content: '''
Klasičan zadatak koji testira razumijevanje petlje s praćenjem VIŠE varijabli odjednom:

def drugi_najveci(lista):
    najveci = drugi = float("-inf")
    for broj in lista:
        if broj > najveci:
            drugi = najveci
            najveci = broj
        elif broj > drugi and broj != najveci:
            drugi = broj
    return drugi

print(drugi_najveci([5, 1, 9, 3, 9, 7]))   # 7

float("-inf") predstavlja "minus beskonačno" - sigurna početna vrijednost manja od bilo kojeg stvarnog broja u listi, tako da prva usporedba uvijek uspije.
''',
    ),
    LessonPage(
      pageNumber: 10,
      title: 'Presjek dvije liste (bez seta)',
      content: '''
Iako je set najbrži način za presjek, korisno je znati napraviti to ručno pomoću petlje, radi vježbe:

def presjek(lista1, lista2):
    rezultat = []
    for x in lista1:
        if x in lista2 and x not in rezultat:
            rezultat.append(x)
    return rezultat

print(presjek([1, 2, 3, 4], [3, 4, 5, 6]))   # [3, 4]

Ova implementacija ima vremensku složenost O(n*m) jer x in lista2 sam po sebi prolazi kroz cijelu lista2 - set verzija (set(lista1) & set(lista2)) je puno brža za velike liste.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb56s2q1',
      type: QuestionType.code,
      prompt: 'Napiši funkciju linearna_pretraga koja vraća indeks broja 23 u listi [4, 8, 15, 16, 23].',
      codeTaskPrompt: 'def linearna_pretraga(lista, trazeni):\n    for i, element in enumerate(lista):\n        if element == trazeni:\n            return i\n    return -1\n\nprint(linearna_pretraga([4, 8, 15, 16, 23], 23))',
      expectedOutput: '4',
    ),
    Question(
      id: 'lb56s2q2',
      type: QuestionType.code,
      prompt: 'Napiši funkciju binarna_pretraga koja pronalazi broj 9 u sortiranoj listi [1, 3, 5, 7, 9, 11].',
      codeTaskPrompt: 'def binarna_pretraga(lista, trazeni):\n    lijevo, desno = 0, len(lista) - 1\n    while lijevo <= desno:\n        sredina = (lijevo + desno) // 2\n        if lista[sredina] == trazeni:\n            return sredina\n        elif lista[sredina] < trazeni:\n            lijevo = sredina + 1\n        else:\n            desno = sredina - 1\n    return -1\n\nprint(binarna_pretraga([1, 3, 5, 7, 9, 11], 9))',
      expectedOutput: '4',
    ),
    Question(
      id: 'lb56s2q3',
      type: QuestionType.code,
      prompt: 'Napiši funkciju koja pronalazi sve indekse broja 3 u listi [1, 3, 3, 5, 3, 7].',
      codeTaskPrompt: 'def sva_pojavljivanja(lista, trazeni):\n    indeksi = []\n    for i, element in enumerate(lista):\n        if element == trazeni:\n            indeksi.append(i)\n    return indeksi\n\nprint(sva_pojavljivanja([1, 3, 3, 5, 3, 7], 3))',
      expectedOutput: '[1, 2, 4]',
    ),
    Question(
      id: 'lb56s2q4',
      type: QuestionType.code,
      prompt: 'Napiši funkciju koja pronalazi drugi najveći broj u listi [5, 1, 9, 3, 9, 7].',
      codeTaskPrompt: 'def drugi_najveci(lista):\n    najveci = drugi = float("-inf")\n    for broj in lista:\n        if broj > najveci:\n            drugi = najveci\n            najveci = broj\n        elif broj > drugi and broj != najveci:\n            drugi = broj\n    return drugi\n\nprint(drugi_najveci([5, 1, 9, 3, 9, 7]))',
      expectedOutput: '7',
    ),
    Question(
      id: 'lb56s2q5',
      type: QuestionType.code,
      prompt: 'Napiši funkciju presjek koja pronalazi zajedničke elemente listi [1,2,3,4] i [3,4,5,6].',
      codeTaskPrompt: 'def presjek(lista1, lista2):\n    rezultat = []\n    for x in lista1:\n        if x in lista2 and x not in rezultat:\n            rezultat.append(x)\n    return rezultat\n\nprint(presjek([1, 2, 3, 4], [3, 4, 5, 6]))',
      expectedOutput: '[3, 4]',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 3 (stranice 11-15) — Matrice i 2D algoritmi
// ---------------------------------------------------------------------

final LessonSection listB56S3 = LessonSection(
  sectionIndex: 2,
  pages: [
    LessonPage(
      pageNumber: 11,
      title: 'Zbrajanje dvije matrice',
      content: '''
Zbrajanje matrica zbraja elemente na ISTOJ poziciji u obje matrice:

def zbroji_matrice(m1, m2):
    rezultat = []
    for i in range(len(m1)):
        red = []
        for j in range(len(m1[0])):
            red.append(m1[i][j] + m2[i][j])
        rezultat.append(red)
    return rezultat

m1 = [[1, 2], [3, 4]]
m2 = [[5, 6], [7, 8]]
print(zbroji_matrice(m1, m2))   # [[6, 8], [10, 12]]

Ovaj obrazac (ugniježđena petlja koja gradi rezultat red po red) je temelj za rad s inženjerskim/matematičkim izračunima u kodu.
''',
    ),
    LessonPage(
      pageNumber: 12,
      title: 'Transponiranje matrice',
      content: '''
Transponiranje zamjenjuje redove sa stupcima:

def transponiraj(matrica):
    redovi = len(matrica)
    stupci = len(matrica[0])
    rezultat = [[0] * redovi for _ in range(stupci)]
    for i in range(redovi):
        for j in range(stupci):
            rezultat[j][i] = matrica[i][j]
    return rezultat

m = [[1, 2, 3], [4, 5, 6]]
print(transponiraj(m))   # [[1, 4], [2, 5], [3, 6]]

Element na poziciji [i][j] u originalu postaje element na poziciji [j][i] u rezultatu - klasičan algoritamski zadatak iz linearne algebre.
''',
    ),
    LessonPage(
      pageNumber: 13,
      title: 'Množenje matrice skalarom',
      content: '''
Množenje SVAKOG elementa matrice istim brojem (skalarom):

def mnozi_skalarom(matrica, skalar):
    return [[element * skalar for element in red] for red in matrica]

m = [[1, 2], [3, 4]]
print(mnozi_skalarom(m, 3))   # [[3, 6], [9, 12]]

Ovdje je korišten ugniježđeni list comprehension - vanjski prolazi kroz redove, unutarnji kroz elemente svakog reda, množeći svaki sa skalarom.
''',
    ),
    LessonPage(
      pageNumber: 14,
      title: 'Pronalaženje najvećeg elementa u matrici',
      content: '''
Za pronalazak najvećeg elementa u 2D strukturi, potrebne su ugniježđene petlje ili kombinacija s ugrađenim funkcijama:

def najveci_u_matrici(matrica):
    najveci = matrica[0][0]
    for red in matrica:
        for element in red:
            if element > najveci:
                najveci = element
    return najveci

m = [[3, 7, 2], [8, 1, 9], [4, 6, 5]]
print(najveci_u_matrici(m))   # 9

Alternativno, kompaktnije s ugrađenim max() i list comprehensionom:

print(max(max(red) for red in m))   # 9
''',
    ),
    LessonPage(
      pageNumber: 15,
      title: 'Rekapitulacija - 2D strukture u praksi',
      content: '''
Rad s matricama (liste listi) je čest u inženjerskim primjenama - baš kao što ćeš možda trebati za obradu podataka iz mjerenja (npr. tvoj wind tunnel eksperiment s Cobra probom, gdje su rezultati organizirani u 2D mrežu pozicija):

1. Ugniježđene petlje su temeljni alat za obradu 2D podataka
2. Ugniježđeni list comprehension gradi novu matricu kompaktno
3. max()/min() s generatorskim izrazom pojednostavljuje traženje ekstrema
4. Transponiranje, zbrajanje i množenje skalarom su osnovne operacije nad matricama

Ove tehnike direktno se primjenjuju kod obrade eksperimentalnih podataka - npr. spremanje mjerenja brzine zraka po pozicijama u 2D mrežu, kao u tvom diplomskom radu.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb56s3q1',
      type: QuestionType.code,
      prompt: 'Napiši funkciju koja zbraja matrice [[1,2],[3,4]] i [[5,6],[7,8]].',
      codeTaskPrompt: 'def zbroji_matrice(m1, m2):\n    rezultat = []\n    for i in range(len(m1)):\n        red = []\n        for j in range(len(m1[0])):\n            red.append(m1[i][j] + m2[i][j])\n        rezultat.append(red)\n    return rezultat\n\nprint(zbroji_matrice([[1,2],[3,4]], [[5,6],[7,8]]))',
      expectedOutput: '[[6, 8], [10, 12]]',
    ),
    Question(
      id: 'lb56s3q2',
      type: QuestionType.code,
      prompt: 'Napiši funkciju koja transponira matricu [[1,2,3],[4,5,6]].',
      codeTaskPrompt: 'def transponiraj(matrica):\n    redovi = len(matrica)\n    stupci = len(matrica[0])\n    rezultat = [[0] * redovi for _ in range(stupci)]\n    for i in range(redovi):\n        for j in range(stupci):\n            rezultat[j][i] = matrica[i][j]\n    return rezultat\n\nprint(transponiraj([[1,2,3],[4,5,6]]))',
      expectedOutput: '[[1, 4], [2, 5], [3, 6]]',
    ),
    Question(
      id: 'lb56s3q3',
      type: QuestionType.code,
      prompt: 'Napiši kod koji množi matricu [[1,2],[3,4]] skalarom 3 koristeći ugniježđeni list comprehension.',
      codeTaskPrompt: 'm = [[1, 2], [3, 4]]\nrezultat = [[element * 3 for element in red] for red in m]\nprint(rezultat)',
      expectedOutput: '[[3, 6], [9, 12]]',
    ),
    Question(
      id: 'lb56s3q4',
      type: QuestionType.code,
      prompt: 'Napiši kod koji pronalazi najveći element matrice [[3,7,2],[8,1,9],[4,6,5]] koristeći max() s generatorom.',
      codeTaskPrompt: 'm = [[3,7,2],[8,1,9],[4,6,5]]\nprint(max(max(red) for red in m))',
      expectedOutput: '9',
    ),
  ],
);

// ---------------------------------------------------------------------
// Sekcija 4 (stranice 16-20) — Rekurzivni algoritmi nad listama
// ---------------------------------------------------------------------

final LessonSection listB56S4 = LessonSection(
  sectionIndex: 3,
  pages: [
    LessonPage(
      pageNumber: 16,
      title: 'Rekurzivno zbrajanje liste',
      content: '''
Umjesto petlje, zbrajanje liste možeš napisati rekurzivno - klasična vježba rekurzivnog razmišljanja:

def zbroji_rekurzivno(lista):
    if not lista:          # bazni slučaj: prazna lista
        return 0
    return lista[0] + zbroji_rekurzivno(lista[1:])

print(zbroji_rekurzivno([1, 2, 3, 4]))   # 10

Ideja: zbroj cijele liste = prvi element + zbroj OSTATKA liste. lista[1:] stvara novu (kraću) listu za svaki rekurzivni poziv, sve dok lista ne postane prazna.
''',
    ),
    LessonPage(
      pageNumber: 17,
      title: 'Rekurzivni binary search',
      content: '''
Binarna pretraga se prirodno može napisati i rekurzivno:

def binarna_rekurzivno(lista, trazeni, lijevo=0, desno=None):
    if desno is None:
        desno = len(lista) - 1
    if lijevo > desno:
        return -1
    sredina = (lijevo + desno) // 2
    if lista[sredina] == trazeni:
        return sredina
    elif lista[sredina] < trazeni:
        return binarna_rekurzivno(lista, trazeni, sredina + 1, desno)
    else:
        return binarna_rekurzivno(lista, trazeni, lijevo, sredina - 1)

print(binarna_rekurzivno([1, 3, 5, 7, 9], 7))   # 3

Svaki rekurzivni poziv smanjuje prostor pretrage (lijevo/desno granice) - bazni slučaj je kad lijevo > desno (nije pronađeno).
''',
    ),
    LessonPage(
      pageNumber: 18,
      title: 'Merge sort - rekurzivno sortiranje',
      content: '''
Merge sort dijeli listu na pola, rekurzivno sortira svaku polovicu, pa ih spaja (merge):

def merge_sort(lista):
    if len(lista) <= 1:
        return lista
    sredina = len(lista) // 2
    lijeva = merge_sort(lista[:sredina])
    desna = merge_sort(lista[sredina:])
    return spoji(lijeva, desna)

def spoji(a, b):
    rezultat = []
    i = j = 0
    while i < len(a) and j < len(b):
        if a[i] <= b[j]:
            rezultat.append(a[i]); i += 1
        else:
            rezultat.append(b[j]); j += 1
    rezultat.extend(a[i:])
    rezultat.extend(b[j:])
    return rezultat

print(merge_sort([5, 2, 8, 1, 9]))   # [1, 2, 5, 8, 9]

Za razliku od bubble/selection/insertion sorta (O(n²)), merge sort postiže O(n log n) - značajno brži za velike liste.
''',
    ),
    LessonPage(
      pageNumber: 19,
      title: 'Generiranje svih podskupova (rekurzivno)',
      content: '''
Klasičan napredni zadatak: generiraj sve moguće podskupove liste, koristeći rekurziju:

def svi_podskupovi(lista):
    if not lista:
        return [[]]
    prvi = lista[0]
    ostatak = svi_podskupovi(lista[1:])
    return ostatak + [[prvi] + p for p in ostatak]

print(svi_podskupovi([1, 2]))   # [[], [2], [1], [1, 2]]

Za svaki element, postoje dvije mogućnosti: BEZ njega (ostatak) ili S njim (dodan svakom postojećem podskupu). Broj podskupova raste eksponencijalno (2^n).
''',
    ),
    LessonPage(
      pageNumber: 20,
      title: 'Rekapitulacija - liste kroz sve tri Bloom razine',
      content: '''
Ovim smo zaokružili temu Liste kroz sve tri razine:

Bloom 1-2 (Osnove): indeksiranje, slicing, osnovne metode, jednostavna iteracija
Bloom 3-4 (Primjena/analiza): liste unutar rječnika i objekata, enkapsulacija u klase, matrice i grafovi kao strukture
Bloom 5-6 (Evaluacija/kreiranje): pisanje algoritama sortiranja, pretrage, rada s matricama i rekurzivnih rješenja

Ovaj napredak - od "znam koristiti listu" do "mogu napisati algoritam koji rješava problem koristeći listu" - upravo je ono što Bloom taksonomija mjeri. Isti obrazac primjenjuje se i na teme Varijable i If/else.
''',
    ),
  ],
  questions: [
    Question(
      id: 'lb56s4q1',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju koja zbraja sve elemente liste [1, 2, 3, 4].',
      codeTaskPrompt: 'def zbroji_rekurzivno(lista):\n    if not lista:\n        return 0\n    return lista[0] + zbroji_rekurzivno(lista[1:])\n\nprint(zbroji_rekurzivno([1, 2, 3, 4]))',
      expectedOutput: '10',
    ),
    Question(
      id: 'lb56s4q2',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu binarnu pretragu koja pronalazi broj 7 u sortiranoj listi [1, 3, 5, 7, 9].',
      codeTaskPrompt: 'def binarna_rekurzivno(lista, trazeni, lijevo=0, desno=None):\n    if desno is None:\n        desno = len(lista) - 1\n    if lijevo > desno:\n        return -1\n    sredina = (lijevo + desno) // 2\n    if lista[sredina] == trazeni:\n        return sredina\n    elif lista[sredina] < trazeni:\n        return binarna_rekurzivno(lista, trazeni, sredina + 1, desno)\n    else:\n        return binarna_rekurzivno(lista, trazeni, lijevo, sredina - 1)\n\nprint(binarna_rekurzivno([1, 3, 5, 7, 9], 7))',
      expectedOutput: '3',
    ),
    Question(
      id: 'lb56s4q3',
      type: QuestionType.code,
      prompt: 'Napiši merge_sort funkciju (s pomoćnom spoji funkcijom) i sortiraj [5, 2, 8, 1, 9].',
      codeTaskPrompt: 'def merge_sort(lista):\n    if len(lista) <= 1:\n        return lista\n    sredina = len(lista) // 2\n    lijeva = merge_sort(lista[:sredina])\n    desna = merge_sort(lista[sredina:])\n    return spoji(lijeva, desna)\n\ndef spoji(a, b):\n    rezultat = []\n    i = j = 0\n    while i < len(a) and j < len(b):\n        if a[i] <= b[j]:\n            rezultat.append(a[i]); i += 1\n        else:\n            rezultat.append(b[j]); j += 1\n    rezultat.extend(a[i:])\n    rezultat.extend(b[j:])\n    return rezultat\n\nprint(merge_sort([5, 2, 8, 1, 9]))',
      expectedOutput: '[1, 2, 5, 8, 9]',
    ),
    Question(
      id: 'lb56s4q4',
      type: QuestionType.code,
      prompt: 'Napiši rekurzivnu funkciju koja generira sve podskupove liste [1, 2].',
      codeTaskPrompt: 'def svi_podskupovi(lista):\n    if not lista:\n        return [[]]\n    prvi = lista[0]\n    ostatak = svi_podskupovi(lista[1:])\n    return ostatak + [[prvi] + p for p in ostatak]\n\nprint(svi_podskupovi([1, 2]))',
      expectedOutput: '[[], [2], [1], [1, 2]]',
    ),
  ],
);

final Lesson listeBloom56 = Lesson(
  id: 203,
  title: 'Liste - Pisanje i izvršavanje koda',
  bloomLevels: '5-6',
  questionType: QuestionType.code,
  sections: [listB56S1, listB56S2, listB56S3, listB56S4],
);