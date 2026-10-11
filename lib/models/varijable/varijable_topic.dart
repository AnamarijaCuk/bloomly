// lib/models/varijable/varijable_topic.dart
//
// Spaja sve 3 Bloom razine teme "Varijable" u jedan Topic objekt.

import '../lesson_model.dart';
import 'bloom12.dart';
import 'bloom34.dart';
import 'bloom56.dart';

final Topic topicVarijable = Topic(
  id: 'varijable',
  title: 'Varijable',
  bloomLessons: [
    varijableBloom12,
    varijableBloom34,
    varijableBloom56,
  ],
);