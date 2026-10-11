// lib/bloom_level_select_screen.dart
//
// Nakon odabira teme (Varijable/Liste/If-else) na Home ekranu, ovaj ekran
// prikazuje 3 kartice za Bloom razine (1-2, 3-4, 5-6) unutar te teme.
// Svaka kartica pamti napredak - klik nastavlja TOČNO ondje gdje je korisnik stao.

import 'package:flutter/material.dart';
import 'models/lesson_model.dart';
import 'widgets/app_background.dart';
import 'lesson_page_screen.dart';
import 'services/progress_service.dart';

const Color _brand = Color(0xFF378ADD);

class BloomLevelSelectScreen extends StatefulWidget {
  final Topic topic;

  const BloomLevelSelectScreen({super.key, required this.topic});

  @override
  State<BloomLevelSelectScreen> createState() =>
      _BloomLevelSelectScreenState();
}

class _BloomLevelSelectScreenState extends State<BloomLevelSelectScreen> {
  Map<int, LessonProgress> _napredakPoLekciji = {};
  bool _ucitavanje = true;

  @override
  void initState() {
    super.initState();
    _ucitajNapredak();
  }

  Future<void> _ucitajNapredak() async {
    final mapa = <int, LessonProgress>{};
    for (final lekcija in widget.topic.bloomLessons) {
      final napredak = await ProgressService.getProgress(lekcija.id);
      if (napredak != null) mapa[lekcija.id] = napredak;
    }
    if (!mounted) return;
    setState(() {
      _napredakPoLekciji = mapa;
      _ucitavanje = false;
    });
  }

  // Ikone specifične po Bloom razini - odabrane prema PRIRODI te razine
  // (osnove/čitanje, strukture/organizacija, pisanje koda), ne generičke.
  IconData _iconForBloom(String bloomLevels) {
    switch (bloomLevels) {
      case '1-2':
        return Icons.menu_book_rounded; // osnove, čitanje gradiva
      case '3-4':
        return Icons.account_tree_rounded; // strukture, organizacija, OOP
      case '5-6':
        return Icons.terminal_rounded; // pisanje/izvršavanje koda
      default:
        return Icons.school_outlined;
    }
  }

  /// Jedinstven, sadržajno precizan naziv za SVAKU od 9 lekcija - umjesto
  /// generičkog dijela naziva koji se ponavlja na više tema 
  static const Map<int, String> _naziviLekcija = {
    // Varijable
    101: 'Varijable i memorija',
    102: 'Rječnici, strukture i OOP',
    103: 'Petlje, rekurzija i datoteke',
    // Liste
    201: 'Osnove liste',
    202: 'Liste u strukturama i OOP',
    203: 'Algoritmi sortiranja i pretrage',
    // If/else
    301: 'Uvjeti i petlje',
    302: 'Uvjeti u OOP i automati',
    303: 'Algoritmi i simulacije',
  };

  String _specificniOpis(Lesson lesson) {
    return _naziviLekcija[lesson.id] ?? lesson.title;
  }

  String _bloomKategorija(String bloomLevels) {
    switch (bloomLevels) {
      case '1-2':
        return 'Pamćenje i razumijevanje';
      case '3-4':
        return 'Primjena i analiza';
      case '5-6':
        return 'Evaluacija i kreiranje';
      default:
        return '';
    }
  }

  String _questionTypeLabel(QuestionType type) {
    switch (type) {
      case QuestionType.objective:
        return 'Objektivna pitanja';
      case QuestionType.matching:
        return 'Uparivanje i hijerarhija';
      case QuestionType.hierarchy:
        return 'Uparivanje i hijerarhija';
      case QuestionType.code:
        return 'Pisanje koda';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                    color: _brand.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: _brand),
            ),
          ),
        ),
        title: Text(
          widget.topic.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _ucitavanje
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                          20, kToolbarHeight + 24, 20, 20),
                      shrinkWrap: true,
                      itemCount: widget.topic.bloomLessons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final lekcija = widget.topic.bloomLessons[index];
                        final napredak = _napredakPoLekciji[lekcija.id];
                        return _BloomCard(
                          lesson: lekcija,
                          icon: _iconForBloom(lekcija.bloomLevels),
                          naslovKartice: _specificniOpis(lekcija),
                          bloomKategorija:
                              _bloomKategorija(lekcija.bloomLevels),
                          questionTypeLabel:
                              _questionTypeLabel(lekcija.questionType),
                          napredak: napredak,
                          onTap: () async {
                            int pocetnaSekcija = 0;
                            if (napredak != null) {
                              pocetnaSekcija = napredak.sectionIndex
                                  .clamp(0, lekcija.sections.length - 1);
                            }
                            if (!context.mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonPageScreen(
                                  lesson: lekcija,
                                  initialSectionIndex: pocetnaSekcija,
                                ),
                              ),
                            );
                            _ucitajNapredak();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BloomCard extends StatelessWidget {
  final Lesson lesson;
  final IconData icon;
  final String naslovKartice;
  final String bloomKategorija;
  final String questionTypeLabel;
  final LessonProgress? napredak;
  final VoidCallback onTap;

  const _BloomCard({
    required this.lesson,
    required this.icon,
    required this.naslovKartice,
    required this.bloomKategorija,
    required this.questionTypeLabel,
    required this.napredak,
    required this.onTap,
  });

  String? get _statusLabel {
    if (napredak == null) return null;
    if (napredak!.completed) return 'Završeno';
    return 'U tijeku - nastavi';
  }

  Color get _statusColor {
    if (napredak?.completed == true) return const Color(0xFF1D9E75);
    return const Color(0xFFB4650E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _brand.withOpacity(0.10),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _brand.withOpacity(0.16),
                        _brand.withOpacity(0.26),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: _brand, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bloom ${lesson.bloomLevels} · $bloomKategorija',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _brand,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        naslovKartice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _Chip(text: questionTypeLabel),
                          if (_statusLabel != null)
                            _Chip(text: _statusLabel!, color: _statusColor),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _brand.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right,
                      color: _brand, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color? color;
  const _Chip({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: c != null ? c.withOpacity(0.10) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: c ?? Colors.black54,
        ),
      ),
    );
  }
}