// lib/services/progress_service.dart
//
// Sprema i dohvaća napredak korisnika kroz lekcije (Supabase tablica "progress").

import 'package:sentry_flutter/sentry_flutter.dart';
import 'supabase_service.dart';

class LessonProgress {
  final int lessonId;
  final int sectionIndex;
  final bool completed;
  final int? lastScore;
  final int? lastTotal;
  final DateTime updatedAt;

  LessonProgress({
    required this.lessonId,
    required this.sectionIndex,
    required this.completed,
    this.lastScore,
    this.lastTotal,
    required this.updatedAt,
  });

  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonId: map['lesson_id'] as int,
      sectionIndex: map['section_index'] as int,
      completed: map['completed'] as bool,
      lastScore: map['last_score'] as int?,
      lastTotal: map['last_total'] as int?,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class ProgressService {
  /// Sprema rezultat kviza za jednu sekciju. [completed] = true ako je ovo bila
  /// zadnja sekcija lekcije i korisnik je sve točno odgovorio (lekcija gotova).
  static Future<void> saveQuizResult({
    required int lessonId,
    required int sectionIndex,
    required int score,
    required int total,
    required bool completed,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabase.from('progress').upsert({
        'user_id': userId,
        'lesson_id': lessonId,
        'section_index': sectionIndex,
        'completed': completed,
        'last_score': score,
        'last_total': total,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,lesson_id');
    } catch (e, stackTrace) {
      // Ne prekidamo tok aplikacije ako spremanje napretka ne uspije -
      // korisnik i dalje može nastaviti učiti, samo se napredak neće spremiti.
      // Šaljemo na Sentry da znamo ako se ovo počne događati u praksi.
      print('Greška pri spremanju napretka: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({'mjesto': 'ProgressService.saveQuizResult'}),
      );
    }
  }

  /// Dohvaća napredak za jednu specifičnu lekciju (ili null ako ne postoji).
  static Future<LessonProgress?> getProgress(int lessonId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final result = await supabase
          .from('progress')
          .select()
          .eq('user_id', userId)
          .eq('lesson_id', lessonId)
          .maybeSingle();

      if (result == null) return null;
      return LessonProgress.fromMap(result);
    } catch (e, stackTrace) {
      print('Greška pri dohvaćanju napretka: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({'mjesto': 'ProgressService.getProgress'}),
      );
      return null;
    }
  }

  /// Dohvaća SAV napredak korisnika, sortiran po zadnjoj aktivnosti (najnoviji prvi).
  /// Koristi se za "Zadnji rezultat" na Home ekranu.
  static Future<List<LessonProgress>> getAllProgress() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final result = await supabase
          .from('progress')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (result as List)
          .map((row) => LessonProgress.fromMap(row as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('Greška pri dohvaćanju napretka: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({'mjesto': 'ProgressService.getAllProgress'}),
      );
      return [];
    }
  }
}