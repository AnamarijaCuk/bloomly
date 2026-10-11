// lib/models/topics_data.dart
//
// Glavni popis svih tema. Svaka tema ima 3 lekcije (Bloom 1-2, 3-4, 5-6).

import 'lesson_model.dart';
import 'varijable/varijable_topic.dart';
import 'liste/liste_topic.dart';
import 'ifelse/ifelse_topic.dart';

final List<Topic> sveTeme = [
  topicVarijable,
  topicListe,
  topicIfElse,
];

/// Pronalazi lekciju (Bloom razinu) po njenom ID-u, kroz sve teme.
/// Vraća null ako lekcija s tim ID-om ne postoji.
Lesson? findLessonById(int lessonId) {
  for (final tema in sveTeme) {
    for (final lekcija in tema.bloomLessons) {
      if (lekcija.id == lessonId) return lekcija;
    }
  }
  return null;
}