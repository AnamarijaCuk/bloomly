import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'services/progress_service.dart';
import 'profile_screen.dart';
import 'models/lesson_model.dart';
import 'models/topics_data.dart';
import 'bloom_level_select_screen.dart';
import 'widgets/app_background.dart';

// ===================== HOME =====================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryBlue = Color(0xFF378ADD);
  static const Color primaryBlueDark = Color(0xFF185FA5);

  Map<int, LessonProgress> _napredakPoLekciji = {};
  bool _ucitavanje = true;

  @override
  void initState() {
    super.initState();
    _ucitajNapredak();
  }

  Future<void> _ucitajNapredak() async {
    final sviNapredci = await ProgressService.getAllProgress();
    if (!mounted) return;
    setState(() {
      _napredakPoLekciji = {
        for (final p in sviNapredci) p.lessonId: p,
      };
      _ucitavanje = false;
    });
  }

  (Lesson, LessonProgress)? _najnapredniji(Topic tema) {
    (Lesson, LessonProgress)? rezultat;
    for (final lekcija in tema.bloomLessons) {
      final napredak = _napredakPoLekciji[lekcija.id];
      if (napredak != null) {
        rezultat = (lekcija, napredak);
      }
    }
    return rezultat;
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String? ?? '';
    final displayName = fullName.isNotEmpty ? fullName.split(' ').first : 'Korisniče';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BLOOMLY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dobrodošao/la',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(displayName,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person, color: primaryBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text('Teme za učenje',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54)),
                  const SizedBox(height: 10),
                  _buildTopicCard(context, sveTeme[0], Icons.data_object_rounded),
                  _buildTopicCard(context, sveTeme[1], Icons.format_list_bulleted_rounded),
                  _buildTopicCard(context, sveTeme[2], Icons.alt_route_rounded),
                  const SizedBox(height: 24),
                  const Text('Napredak po temama',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54)),
                  const SizedBox(height: 10),
                  if (_ucitavanje)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else ...[
                    _buildNapredakKartica(sveTeme[0]),
                    _buildNapredakKartica(sveTeme[1]),
                    _buildNapredakKartica(sveTeme[2]),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _glassDecoration({double opacity = 1.0}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
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

  Widget _buildNapredakKartica(Topic tema) {
    final rezultat = _najnapredniji(tema);

    if (rezultat == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: _glassDecoration(opacity: 0.55),
        child: Row(
          children: [
            Expanded(
              child: Text(
                tema.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54),
              ),
            ),
            const Text(
              'Još nisi počeo/la',
              style: TextStyle(color: Colors.black38, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final (lekcija, napredak) = rezultat;
    final zavrseno = napredak.completed;
    final tocno = napredak.lastScore ?? 0;
    final ukupno = napredak.lastTotal ?? 0;
    final omjer = ukupno > 0 ? tocno / ukupno : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _glassDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tema.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: zavrseno
                            ? const Color(0xFFE1F5EE)
                            : const Color(0xFFFFF1DE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            zavrseno
                                ? Icons.check_circle
                                : Icons.hourglass_bottom,
                            size: 12,
                            color: zavrseno
                                ? const Color(0xFF0F6E56)
                                : const Color(0xFFB4650E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Bloom ${lekcija.bloomLevels} - ${zavrseno ? "Završeno" : "U tijeku"}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: zavrseno
                                  ? const Color(0xFF0F6E56)
                                  : const Color(0xFFB4650E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (ukupno > 0)
                Text(
                  '$tocno/$ukupno',
                  style: const TextStyle(
                    color: primaryBlueDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          if (ukupno > 0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: omjer,
                minHeight: 6,
                backgroundColor: primaryBlue.withOpacity(0.10),
                valueColor: AlwaysStoppedAnimation<Color>(
                  zavrseno ? const Color(0xFF1D9E75) : primaryBlue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Topic topic, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _glassDecoration(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BloomLevelSelectScreen(topic: topic),
              ),
            );
            _ucitajNapredak();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryBlue.withOpacity(0.16),
                        primaryBlue.withOpacity(0.24),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: primaryBlue, size: 22),
                ),
                const SizedBox(width: 14),
                Text(topic.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right,
                      color: primaryBlue, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}