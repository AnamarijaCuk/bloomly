// lib/lesson_quiz_screen.dart
//
// Prikazuje pitanja na kraju sekcije, jedno po jedno. Podržava:
// - objective: odabir točnog odgovora
// - matching: uparivanje pojma s definicijom preko dropdowna
// - hierarchy: slaganje redoslijeda preko strelica gore/dolje
// - code: korisnik upiše kod, kod se izvršava na Pistonu, točnost se utvrđuje
//   determinističkom usporedbom ispisa, a Gemini daje objašnjenje
//
// Na kraju: ako su svi odgovori točni, nastavlja se na sljedeću sekciju
// (ili nazad na Bloom razinu ako je ovo bila zadnja sekcija). Ako nisu svi
// točni, korisnik se vraća na početak trenutne sekcije.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/lesson_model.dart';
import 'widgets/app_background.dart';
import 'lesson_page_screen.dart';
import 'services/progress_service.dart';
import 'services/gemini_service.dart';
import 'services/piston_service.dart';
import 'services/output_comparator.dart';

class LessonQuizScreen extends StatefulWidget {
  final Lesson lesson;
  final LessonSection section;

  const LessonQuizScreen({
    super.key,
    required this.lesson,
    required this.section,
  });

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  static const Color primaryBlue = Color(0xFF378ADD);

  late List<bool?> _answeredCorrectly; // null = nije odgovoreno
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _answeredCorrectly =
        List<bool?>.filled(widget.section.questions.length, null);
  }

  Question get _currentQuestion =>
      widget.section.questions[_currentIndex];

  bool get _isLastQuestion =>
      _currentIndex == widget.section.questions.length - 1;

  void _recordAnswer(bool correct) {
    setState(() {
      _answeredCorrectly[_currentIndex] = correct;
    });
  }

  void _goToNextQuestion() {
    if (!_isLastQuestion) {
      setState(() => _currentIndex++);
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    final tocno = _answeredCorrectly.where((a) => a == true).length;
    final ukupno = _answeredCorrectly.length;
    final sviTocni = tocno == ukupno;
    final trenutniIndeks = widget.section.sectionIndex;
    final jeZadnjaSekcija =
        trenutniIndeks == widget.lesson.sections.length - 1;

    // Odredi GDJE korisnik treba nastaviti idući put kad se vrati u ovu lekciju:
    // - ako je sve točno i ima sljedeću sekciju -> nastavlja na sljedećoj
    // - ako je sve točno i ovo je bila zadnja sekcija -> lekcija gotova, ostaje na zadnjoj
    // - ako nije sve točno -> ostaje na istoj sekciji (za ponavljanje)
    final tockaNastavka = sviTocni
        ? (jeZadnjaSekcija ? trenutniIndeks : trenutniIndeks + 1)
        : trenutniIndeks;
    final zavrseno = sviTocni && jeZadnjaSekcija;

    // Spremi napredak u Supabase (ne blokira UI - radi se u pozadini)
    ProgressService.saveQuizResult(
      lessonId: widget.lesson.id,
      sectionIndex: tockaNastavka,
      score: tocno,
      total: ukupno,
      completed: zavrseno,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(sviTocni ? 'Odlično!' : 'Sekcija završena'),
        content: Text(
          sviTocni
              ? 'Točno si odgovorila na sve $ukupno pitanja! Nastavljaš dalje.'
              : 'Točno: $tocno od $ukupno. Vraćamo te na dio gradiva vezan za prvo pitanje koje si promašila.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // zatvori dialog
              _finishQuiz(sviTocni);
            },
            child: Text(sviTocni ? 'Nastavi dalje' : 'Vrati se na to gradivo'),
          ),
        ],
      ),
    );
  }

  void _finishQuiz(bool sviTocni) {
    final sections = widget.lesson.sections;
    final trenutniIndeks = widget.section.sectionIndex;

    if (sviTocni) {
      final imaSljedecu = trenutniIndeks < sections.length - 1;
      if (imaSljedecu) {
        // Ukloni kviz ekran, pa zamijeni LessonPageScreen ispod njega
        // novim - stog ostaje čist (BloomLevelSelectScreen -> LessonPageScreen).
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LessonPageScreen(
              lesson: widget.lesson,
              initialSectionIndex: trenutniIndeks + 1,
            ),
          ),
        );
      } else {
        // Zadnja sekcija, sve točno - lekcija gotova.
        Navigator.of(context).pop(); // zatvori LessonQuizScreen
        Navigator.of(context).pop(); // zatvori LessonPageScreen
      }
    } else {
      // Ne vraćamo na sam početak - vraćamo na stranicu koja otprilike
      // odgovara PRVOM pitanju na koje je odgovoreno netočno. Pitanja su
      // ravnomjerno "raspoređena" preko stranica sekcije, pa proporcionalno
      // preslikavamo indeks pitanja na indeks stranice.
      final prvaGreskaIndeks = _answeredCorrectly.indexWhere((a) => a == false);
      final brojPitanja = widget.section.questions.length;
      final brojStranica = widget.section.pages.length;

      int stranicaZaVratiti = 0;
      if (prvaGreskaIndeks != -1 && brojPitanja > 0) {
        stranicaZaVratiti =
            ((prvaGreskaIndeks / brojPitanja) * brojStranica).floor();
        stranicaZaVratiti = stranicaZaVratiti.clamp(0, brojStranica - 1);
      }

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LessonPageScreen(
            lesson: widget.lesson,
            initialSectionIndex: trenutniIndeks,
            initialPageIndex: stranicaZaVratiti,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Pitanje ${_currentIndex + 1} od ${widget.section.questions.length}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: primaryBlue),
            ),
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 20),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: _buildQuestionWidget(q),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Question q) {
    switch (q.type) {
      case QuestionType.objective:
        return _ObjectiveQuestionWidget(
          key: ValueKey(q.id),
          question: q,
          onAnswered: _recordAnswer,
          onNext: _goToNextQuestion,
          isLast: _isLastQuestion,
        );
      case QuestionType.matching:
        return _MatchingQuestionWidget(
          key: ValueKey(q.id),
          question: q,
          onAnswered: _recordAnswer,
          onNext: _goToNextQuestion,
          isLast: _isLastQuestion,
        );
      case QuestionType.hierarchy:
        return _HierarchyQuestionWidget(
          key: ValueKey(q.id),
          question: q,
          onAnswered: _recordAnswer,
          onNext: _goToNextQuestion,
          isLast: _isLastQuestion,
        );
      case QuestionType.code:
        return _CodeQuestionWidget(
          key: ValueKey(q.id),
          question: q,
          onAnswered: _recordAnswer,
          onNext: _goToNextQuestion,
          isLast: _isLastQuestion,
        );
    }
  }
}

// =====================================================================
// OBJECTIVE - odabir točnog odgovora
// =====================================================================

class _ObjectiveQuestionWidget extends StatefulWidget {
  final Question question;
  final void Function(bool correct) onAnswered;
  final VoidCallback onNext;
  final bool isLast;

  const _ObjectiveQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswered,
    required this.onNext,
    required this.isLast,
  });

  @override
  State<_ObjectiveQuestionWidget> createState() =>
      _ObjectiveQuestionWidgetState();
}

class _ObjectiveQuestionWidgetState extends State<_ObjectiveQuestionWidget> {
  static const Color primaryBlue = Color(0xFF378ADD);
  String? _odabrano;
  bool _potvrdjeno = false;

  @override
  Widget build(BuildContext context) {
    final opcije = widget.question.options ?? [];
    final tocanOdgovor = widget.question.correctAnswer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        ...opcije.map((opcija) {
          final jeOdabrano = _odabrano == opcija;
          Color? boja;
          if (_potvrdjeno) {
            if (opcija == tocanOdgovor) {
              boja = Colors.green.shade100;
            } else if (jeOdabrano) {
              boja = Colors.red.shade100;
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: _potvrdjeno
                  ? null
                  : () => setState(() => _odabrano = opcija),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: boja ?? (jeOdabrano ? primaryBlue.withOpacity(0.1) : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: jeOdabrano ? primaryBlue : Colors.transparent,
                  ),
                ),
                child: Text(opcija),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        if (!_potvrdjeno)
          ElevatedButton(
            onPressed: _odabrano == null
                ? null
                : () {
                    final tocno = _odabrano == tocanOdgovor;
                    setState(() => _potvrdjeno = true);
                    widget.onAnswered(tocno);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Potvrdi'),
          )
        else
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(widget.isLast ? 'Završi kviz' : 'Sljedeće pitanje'),
          ),
      ],
    );
  }
}

// =====================================================================
// MATCHING - uparivanje pojma s definicijom preko dropdowna
// =====================================================================

class _MatchingQuestionWidget extends StatefulWidget {
  final Question question;
  final void Function(bool correct) onAnswered;
  final VoidCallback onNext;
  final bool isLast;

  const _MatchingQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswered,
    required this.onNext,
    required this.isLast,
  });

  @override
  State<_MatchingQuestionWidget> createState() =>
      _MatchingQuestionWidgetState();
}

class _MatchingQuestionWidgetState extends State<_MatchingQuestionWidget> {
  static const Color primaryBlue = Color(0xFF378ADD);
  late List<String> _keys;
  late List<String> _shuffledValues;
  late Map<String, String?> _odabrano;
  bool _potvrdjeno = false;

  @override
  void initState() {
    super.initState();
    final pairs = widget.question.matchPairs ?? {};
    _keys = pairs.keys.toList();
    _shuffledValues = pairs.values.toList()..shuffle(Random());
    _odabrano = {for (var k in _keys) k: null};
  }

  @override
  Widget build(BuildContext context) {
    final pairs = widget.question.matchPairs ?? {};
    final sviOdabrani = _odabrano.values.every((v) => v != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        const Text(
          'Za svaki pojam odaberi njegovu definiciju.',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ..._keys.map((kljuc) {
          final tocno = _potvrdjeno && _odabrano[kljuc] == pairs[kljuc];
          final netocno = _potvrdjeno && _odabrano[kljuc] != pairs[kljuc];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tocno
                    ? Colors.green.shade50
                    : netocno
                        ? Colors.red.shade50
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kljuc,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _odabrano[kljuc],
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Odaberi definiciju'),
                    items: _shuffledValues
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: _potvrdjeno
                        ? null
                        : (v) => setState(() => _odabrano[kljuc] = v),
                  ),
                  if (_potvrdjeno && netocno)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Točno: ${pairs[kljuc]}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.red.shade700),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        if (!_potvrdjeno)
          ElevatedButton(
            onPressed: !sviOdabrani
                ? null
                : () {
                    final sveTocno =
                        _keys.every((k) => _odabrano[k] == pairs[k]);
                    setState(() => _potvrdjeno = true);
                    widget.onAnswered(sveTocno);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Potvrdi'),
          )
        else
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(widget.isLast ? 'Završi kviz' : 'Sljedeće pitanje'),
          ),
      ],
    );
  }
}

// =====================================================================
// HIERARCHY - slaganje redoslijeda preko strelica gore/dolje
// =====================================================================

class _HierarchyQuestionWidget extends StatefulWidget {
  final Question question;
  final void Function(bool correct) onAnswered;
  final VoidCallback onNext;
  final bool isLast;

  const _HierarchyQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswered,
    required this.onNext,
    required this.isLast,
  });

  @override
  State<_HierarchyQuestionWidget> createState() =>
      _HierarchyQuestionWidgetState();
}

class _HierarchyQuestionWidgetState extends State<_HierarchyQuestionWidget> {
  static const Color primaryBlue = Color(0xFF378ADD);
  late List<String> _redoslijed;
  bool _potvrdjeno = false;

  @override
  void initState() {
    super.initState();
    _redoslijed = List<String>.from(widget.question.hierarchyItems ?? []);
    do {
      _redoslijed.shuffle(Random());
    } while (_redoslijed.length > 1 &&
        _listEquals(_redoslijed, widget.question.hierarchyItems ?? []));
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _pomakni(int indeks, int smjer) {
    setState(() {
      final novi = indeks + smjer;
      if (novi < 0 || novi >= _redoslijed.length) return;
      final tmp = _redoslijed[indeks];
      _redoslijed[indeks] = _redoslijed[novi];
      _redoslijed[novi] = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tocanRedoslijed = widget.question.hierarchyItems ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        const Text(
          'Koristi strelice da poredaš korake ispravnim redoslijedom.',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ..._redoslijed.asMap().entries.map((entry) {
          final indeks = entry.key;
          final stavka = entry.value;
          final tocnaPozicija = _potvrdjeno &&
              indeks < tocanRedoslijed.length &&
              stavka == tocanRedoslijed[indeks];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _potvrdjeno
                    ? (tocnaPozicija ? Colors.green.shade50 : Colors.red.shade50)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: primaryBlue,
                    child: Text(
                      '${indeks + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(stavka)),
                  if (!_potvrdjeno) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_upward, size: 18),
                      onPressed: indeks == 0 ? null : () => _pomakni(indeks, -1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward, size: 18),
                      onPressed: indeks == _redoslijed.length - 1
                          ? null
                          : () => _pomakni(indeks, 1),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        if (!_potvrdjeno)
          ElevatedButton(
            onPressed: () {
              final tocno = _listEquals(_redoslijed, tocanRedoslijed);
              setState(() => _potvrdjeno = true);
              widget.onAnswered(tocno);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Potvrdi'),
          )
        else
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(widget.isLast ? 'Završi kviz' : 'Sljedeće pitanje'),
          ),
      ],
    );
  }
}

// =====================================================================
// CODE - korisnik piše kod; kod se izvršava na Pistonu, točnost se
// utvrđuje determinističkom usporedbom ispisa, a Gemini daje objašnjenje
// i zasebnu kvalitativnu procjenu koja ne utječe na prolaz.
// =====================================================================

class _CodeQuestionWidget extends StatefulWidget {
  final Question question;
  final void Function(bool correct) onAnswered;
  final VoidCallback onNext;
  final bool isLast;

  const _CodeQuestionWidget({
    super.key,
    required this.question,
    required this.onAnswered,
    required this.onNext,
    required this.isLast,
  });

  @override
  State<_CodeQuestionWidget> createState() => _CodeQuestionWidgetState();
}

enum _CodeStanje { pisanje, ucitavanje, rezultat }

class _CodeQuestionWidgetState extends State<_CodeQuestionWidget> {
  static const Color primaryBlue = Color(0xFF378ADD);
  final TextEditingController _controller = TextEditingController();
  _CodeStanje _stanje = _CodeStanje.pisanje;

  ProvjeraRjesenja? _provjera;      // deterministički ishod provjere
  GeminiCodeFeedback? _objasnjenje; // AI objašnjenje, ne utječe na prolaz

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _provjeriRjesenje() async {
    setState(() {
      _stanje = _CodeStanje.ucitavanje;
      _provjera = null;
      _objasnjenje = null;
    });

    // 1. Izvršavanje koda na Piston poslužitelju.
    final pistonRezultat = await PistonService.runPython(_controller.text);
    if (!mounted) return;

    // 2. Deterministička provjera točnosti - jedino ona određuje prolaz.
    final provjera = OutputComparator.provjeri(
      rezultat: pistonRezultat,
      ocekivaniIspis: widget.question.expectedOutput ?? '',
    );

    setState(() => _provjera = provjera);

    // 3. AI objašnjenje već utvrđenog ishoda.
    final objasnjenje = await GeminiService.objasniRezultat(
      prompt: widget.question.prompt,
      userCode: _controller.text,
      referenceCode: widget.question.codeTaskPrompt ?? '',
      provjera: provjera,
    );
    if (!mounted) return;

    setState(() {
      _objasnjenje = objasnjenje;
      _stanje = _CodeStanje.rezultat;
    });

    // Prolaz se bilježi isključivo na temelju determinističke provjere.
    widget.onAnswered(provjera.prolaz);
  }

  Color get _bojaOkvira {
    switch (_provjera!.ishod) {
      case IshodProvjere.tocno:
        return Colors.green;
      case IshodProvjere.nijeProvjereno:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String get _naslovIshoda {
    switch (_provjera!.ishod) {
      case IshodProvjere.tocno:
        return 'Ispis odgovara očekivanom';
      case IshodProvjere.netocanIspis:
        return 'Ispis se ne podudara s očekivanim';
      case IshodProvjere.greskaIzvrsavanja:
        return 'Izvršavanje prekinuto pogreškom';
      case IshodProvjere.prekoracenoOgranicenje:
        return 'Izvršavanje prekinuto zbog ograničenja';
      case IshodProvjere.nijeProvjereno:
        return 'Nije provjereno';
    }
  }

  IconData get _ikonaIshoda {
    switch (_provjera!.ishod) {
      case IshodProvjere.tocno:
        return Icons.check_circle;
      case IshodProvjere.nijeProvjereno:
        return Icons.help_outline;
      default:
        return Icons.cancel;
    }
  }

  String get _opisIshoda {
    switch (_provjera!.ishod) {
      case IshodProvjere.tocno:
        return 'Ispis tvog koda podudara se s očekivanim ispisom zadatka. '
            'Provjera uspoređuje ispis, a ne način na koji je dobiven.';
      case IshodProvjere.netocanIspis:
        return 'Program se izvršio bez pogreške, ali ispis nije jednak očekivanom.';
      case IshodProvjere.greskaIzvrsavanja:
        return 'Program je prekinut pogreškom, pa traženi ispis nije ni nastao.';
      case IshodProvjere.prekoracenoOgranicenje:
        return 'Program je zaustavljen jer je premašio dopušteno vrijeme izvršavanja '
            'ili dopuštenu količinu memorije.';
      case IshodProvjere.nijeProvjereno:
        if (_provjera!.porukaPogreske.trim().isNotEmpty) {
          return 'Poslužitelj za izvršavanje koda nije odgovorio, pa točnost '
              'rješenja nije bilo moguće utvrditi. Rješenje zato nije označeno '
              'kao točno.';
        }
        return 'Za ovaj zadatak nije definiran očekivani ispis, pa se točnost '
            'rješenja ne može utvrditi usporedbom. Rješenje zato nije označeno '
            'kao točno.';
    }
  }

  Widget _blokKoda(String tekst, {Color boja = Colors.black, Color tekstBoja = Colors.greenAccent}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boja,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tekst,
        style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: tekstBoja),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _CodeInputField(
          controller: _controller,
          enabled: _stanje == _CodeStanje.pisanje,
        ),
        const SizedBox(height: 16),

        if (_stanje == _CodeStanje.pisanje)
          ElevatedButton.icon(
            onPressed: _provjeriRjesenje,
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Provjeri rješenje'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          )
        else if (_stanje == _CodeStanje.ucitavanje)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Pokrećem tvoj kod...',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),
          )
        else ...[
          // --- 1. Ishod determinističke provjere ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _bojaOkvira.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _bojaOkvira),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_ikonaIshoda, color: _bojaOkvira),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_naslovIshoda,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(_opisIshoda, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- 2. AI objašnjenje (ne utječe na prolaz) ---
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, size: 18, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text('AI objašnjenje',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _objasnjenje?.available == true
                      ? _objasnjenje!.feedback
                      : (_objasnjenje?.feedback ??
                          'AI objašnjenje trenutno nije dostupno.'),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          // --- 2b. Ispunjenost zahtjeva zadatka ---
          // Odvojeno od usporedbe ispisa: usporedba provjerava REZULTAT,
          // ova procjena govori o NAČINU izrade. Ne utječe na ocjenu.
          // Prikazuje se samo kada je ispis točan: tada postoji opasnost da se
          // podudaranje ispisa shvati kao potpuno rješenje zadatka.
          if (_provjera!.ishod == IshodProvjere.tocno &&
              _objasnjenje?.available == true &&
              _objasnjenje?.zadovoljavaZahtjev != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _objasnjenje!.zadovoljavaZahtjev!
                        ? Icons.task_alt
                        : Icons.report_problem_outlined,
                    size: 18,
                    color: Colors.brown,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _objasnjenje!.zadovoljavaZahtjev!
                              ? 'Zahtjevi zadatka: ispunjeni'
                              : 'Zahtjevi zadatka: nisu ispunjeni u cijelosti',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Savjetodavna procjena načina izrade, odvojena od usporedbe '
                          'ispisa. Donosi je jezični model i ne utječe na ocjenu.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // --- 3. Stvarni ispis koda ---
          if (_provjera!.stvarniIspis.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Stvarni ispis tvog koda:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            _blokKoda(_provjera!.stvarniIspis),
          ],

          // --- 4. Poruka interpretera ---
          if (_provjera!.porukaPogreske.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
                _provjera!.ishod == IshodProvjere.prekoracenoOgranicenje
                    ? 'Dijagnostika izvršavanja:'
                    : 'Poruka interpretera:',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            _blokKoda(_provjera!.porukaPogreske, tekstBoja: Colors.redAccent),
          ],

          // --- 5. Referentno rješenje i očekivani ispis (samo ako nije točno) ---
          if (!_provjera!.prolaz) ...[
            const SizedBox(height: 16),
            const Text('Kako bi trebalo izgledati:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            _blokKoda(widget.question.codeTaskPrompt ?? '',
                boja: Colors.grey.shade900, tekstBoja: Colors.white),
            if ((widget.question.expectedOutput ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Očekivani ispis:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              _blokKoda(widget.question.expectedOutput ?? ''),
            ],
          ],

          const SizedBox(height: 16),
          if (_provjera!.ishod == IshodProvjere.nijeProvjereno)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _stanje = _CodeStanje.pisanje),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Pokušaj ponovno'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  side: const BorderSide(color: primaryBlue),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(widget.isLast ? 'Završi kviz' : 'Sljedeće pitanje'),
          ),
        ],
      ],
    );
  }
}

// =====================================================================
// _CodeInputField - polje za upis koda s pravim Tab uvlačenjem i
// automatskim nastavkom uvlačenja nakon Enter (kao u pravom editoru koda).
// =====================================================================

class _CodeInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;

  const _CodeInputField({
    required this.controller,
    required this.enabled,
  });

  @override
  State<_CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<_CodeInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _ubaciTekstNaKursor(String tekstZaUbaciti, {int pomakKursora = 0}) {
    final controller = widget.controller;
    final selection = controller.selection;
    final tekst = controller.text;

    // Ako selekcija nije valjana (npr. nije kliknuto u polje), stavi na kraj
    final start = selection.start >= 0 ? selection.start : tekst.length;
    final end = selection.end >= 0 ? selection.end : tekst.length;

    final noviTekst = tekst.replaceRange(start, end, tekstZaUbaciti);
    final novaPozicija = start + tekstZaUbaciti.length + pomakKursora;

    controller.value = TextEditingValue(
      text: noviTekst,
      selection: TextSelection.collapsed(offset: novaPozicija),
    );
  }

  KeyEventResult _obradiTipku(FocusNode node, KeyEvent event) {
    if (widget.enabled == false) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // TAB - ubaci 4 razmaka umjesto prebacivanja fokusa
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      final jeShift = HardwareKeyboard.instance.isShiftPressed;
      if (jeShift) {
        // Shift+Tab - ukloni do 4 razmaka ispred kursora (dedent)
        final controller = widget.controller;
        final selection = controller.selection;
        final tekst = controller.text;
        final start = selection.start;
        if (start >= 4 && tekst.substring(start - 4, start) == '    ') {
          final noviTekst = tekst.replaceRange(start - 4, start, '');
          controller.value = TextEditingValue(
            text: noviTekst,
            selection: TextSelection.collapsed(offset: start - 4),
          );
        }
      } else {
        _ubaciTekstNaKursor('    ');
      }
      return KeyEventResult.handled;
    }

    // ENTER - nastavi uvlačenje s prošlog reda, dodaj dodatno ako red završava s ":"
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final controller = widget.controller;
      final selection = controller.selection;
      final tekst = controller.text;
      final start = selection.start >= 0 ? selection.start : tekst.length;

      final prijeKursora = tekst.substring(0, start);
      final zadnjiNovi = prijeKursora.lastIndexOf('\n');
      final trenutniRed = prijeKursora.substring(zadnjiNovi + 1);

      final uvlacenjeMatch = RegExp(r'^[ \t]*').firstMatch(trenutniRed);
      final postojeceUvlacenje = uvlacenjeMatch?.group(0) ?? '';

      final dodatnoUvlacenje =
          trenutniRed.trimRight().endsWith(':') ? '    ' : '';

      _ubaciTekstNaKursor('\n$postojeceUvlacenje$dodatnoUvlacenje');
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _obradiTipku,
      child: TextField(
        controller: widget.controller,
        maxLines: 10,
        minLines: 8,
        enabled: widget.enabled,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Napiši svoj kod ovdje...',
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}