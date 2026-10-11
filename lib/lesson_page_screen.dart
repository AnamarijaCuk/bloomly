// lib/lesson_page_screen.dart
//
// Ekran za čitanje stranica lekcije, jedna po jedna, unutar trenutne
// LessonSection (5 stranica). Na zadnjoj stranici sekcije, gumb vodi
// na ekran s pitanjima.

import 'package:flutter/material.dart';
import 'models/lesson_model.dart';
import 'widgets/app_background.dart';
import 'lesson_quiz_screen.dart';

class LessonPageScreen extends StatefulWidget {
  final Lesson lesson;
  final int initialSectionIndex;
  final int initialPageIndex; // 0..4 - stranica UNUTAR sekcije na kojoj se kreće

  const LessonPageScreen({
    super.key,
    required this.lesson,
    this.initialSectionIndex = 0,
    this.initialPageIndex = 0,
  });

  @override
  State<LessonPageScreen> createState() => _LessonPageScreenState();
}

class _LessonPageScreenState extends State<LessonPageScreen> {
  static const Color primaryBlue = Color(0xFF378ADD);

  late LessonSection _section;
  late int _pageIndexInSection; // 0..4 unutar trenutne sekcije

  @override
  void initState() {
    super.initState();
    _section = widget.lesson.sections[widget.initialSectionIndex];
    _pageIndexInSection =
        widget.initialPageIndex.clamp(0, _section.pages.length - 1);
  }

  LessonPage get _currentPage => _section.pages[_pageIndexInSection];

  bool get _isFirstPageOfSection => _pageIndexInSection == 0;
  bool get _isLastPageOfSection =>
      _pageIndexInSection == _section.pages.length - 1;

  void _goToPreviousPage() {
    if (!_isFirstPageOfSection) {
      setState(() => _pageIndexInSection--);
    }
  }

  void _goToNextPage() {
    if (!_isLastPageOfSection) {
      setState(() => _pageIndexInSection++);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonQuizScreen(
          lesson: widget.lesson,
          section: _section,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _currentPage;
    final totalPages = widget.lesson.totalPages;
    final progress = page.pageNumber / totalPages;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: const TextStyle(
            fontSize: 18,
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
                child: Column(
                  children: [
                    // --- Progress bar + brojač stranica ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: primaryBlue.withOpacity(0.10),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                primaryBlue),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stranica ${page.pageNumber} od $totalPages',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- Sadržaj stranice - u "plutajućoj" kartici ---
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: _cardDecoration(),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                page.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.content.trim(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Navigacija dolje ---
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isFirstPageOfSection
                                ? null
                                : _goToPreviousPage,
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text('Prethodna'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                  color: Colors.grey.shade300),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _goToNextPage,
                            icon: Icon(
                              _isLastPageOfSection
                                  ? Icons.quiz_outlined
                                  : Icons.arrow_forward,
                              size: 18,
                            ),
                            label: Text(
                              _isLastPageOfSection
                                  ? 'Idi na pitanja'
                                  : 'Sljedeća',
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}