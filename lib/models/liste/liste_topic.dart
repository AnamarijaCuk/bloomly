// lib/models/liste/liste_topic.dart
//
// Spaja sve 3 Bloom razine teme "Liste" u jedan Topic objekt.

import '../lesson_model.dart';
import 'bloom12.dart';
import 'bloom34.dart';
import 'bloom56.dart';

final Topic topicListe = Topic(
  id: 'liste',
  title: 'Liste',
  bloomLessons: [
    listeBloom12,
    listeBloom34,
    listeBloom56,
  ],
);