// lib/models/ifelse/ifelse_topic.dart
//
// Spaja sve 3 Bloom razine teme "If/else" u jedan Topic objekt.

import '../lesson_model.dart';
import 'bloom12.dart';
import 'bloom34.dart';
import 'bloom56.dart';

final Topic topicIfElse = Topic(
  id: 'ifelse',
  title: 'If/else',
  bloomLessons: [
    ifelseBloom12,
    ifelseBloom34,
    ifelseBloom56,
  ],
);