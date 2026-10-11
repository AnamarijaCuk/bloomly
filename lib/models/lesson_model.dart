// lib/models/lesson_model.dart
//
// Modeli podataka za lekcije. Sadržaj (stranice, pitanja) je hardkodiran
// u lessons_data.dart - ovdje su samo definicije klasa.

/// Tip pitanja - ovisi o Bloom razini lekcije.
enum QuestionType {
  /// Lekcija 1 (Bloom 1-2): objektivna pitanja (multiple choice / točno-netočno)
  objective,

  /// Lekcija 2 (Bloom 3-4): uparivanje pojmova ili slaganje hijerarhije/redoslijeda
  matching,
  hierarchy,

  /// Lekcija 3 (Bloom 5-6): korisnik piše/izvršava kod
  code,
}

/// Jedna "stranica" sadržaja unutar lekcije.
class LessonPage {
  final int pageNumber;
  final String title;
  final String content;

  const LessonPage({
    required this.pageNumber,
    required this.title,
    required this.content,
  });
}

/// Jedno pitanje. Ovisno o [type], koriste se različita polja:
/// - objective: [options] + [correctAnswer]
/// - matching: [matchPairs] (pojam -> definicija)
/// - hierarchy: [hierarchyItems] (ispravan redoslijed)
/// - code: [codeTaskPrompt] (opis zadatka) + [expectedOutput] (za provjeru)
class Question {
  final String id;
  final QuestionType type;
  final String prompt;

  // objective
  final List<String>? options;
  final String? correctAnswer;

  // matching
  final Map<String, String>? matchPairs;

  // hierarchy
  final List<String>? hierarchyItems;

  // code (Bloom 5-6)
  final String? codeTaskPrompt;
  final String? expectedOutput;

  const Question({
    required this.id,
    required this.type,
    required this.prompt,
    this.options,
    this.correctAnswer,
    this.matchPairs,
    this.hierarchyItems,
    this.codeTaskPrompt,
    this.expectedOutput,
  });
}

/// Blok od (obično) 5 stranica + set pitanja na kraju bloka.
/// Nakon točnih odgovora korisnik ide na sljedeći [LessonSection].
/// Nakon netočnih odgovora, Gemini odlučuje na koju raniju stranicu
/// (unutar [returnToPageOptions]) se korisnik vraća.
class LessonSection {
  final int sectionIndex; // 0, 1, 2, 3 (za 20 stranica / 5 po sekciji = 4 sekcije)
  final List<LessonPage> pages;
  final List<Question> questions;

  const LessonSection({
    required this.sectionIndex,
    required this.pages,
    required this.questions,
  });

  int get firstPageNumber => pages.first.pageNumber;
  int get lastPageNumber => pages.last.pageNumber;
}

/// Cijela lekcija (1, 2 ili 3), vezana za Bloom razine.
class Lesson {
  final int id;
  final String title;
  final String bloomLevels; // npr. "1-2", "3-4", "5-6"
  final QuestionType questionType;
  final List<LessonSection> sections;

  const Lesson({
    required this.id,
    required this.title,
    required this.bloomLevels,
    required this.questionType,
    required this.sections,
  });

  int get totalPages => sections.fold(0, (sum, s) => sum + s.pages.length);
}

/// Tema (npr. "Varijable", "Liste", "If/else") koja sadrži TOČNO 3 lekcije,
/// po jednu za svaku Bloom razinu (1-2, 3-4, 5-6).
class Topic {
  final String id; // 'varijable', 'liste', 'ifelse'
  final String title; // prikazni naziv, npr. "Varijable"
  final List<Lesson> bloomLessons; // uvijek 3: [Bloom1-2, Bloom3-4, Bloom5-6]

  const Topic({
    required this.id,
    required this.title,
    required this.bloomLessons,
  });
}