import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'services/progress_service.dart';
import 'models/topics_data.dart';
import 'auth_screens.dart';
import 'widgets/app_background.dart';

// ===================== PROFILE =====================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryBlue = Color(0xFF378ADD);
  static const Color primaryBlueDark = Color(0xFF185FA5);

  int _zavrsenihLekcija = 0;
  int _ukupnoLekcija = 0;
  bool _ucitavanje = true;

  @override
  void initState() {
    super.initState();
    _ucitajSazetak();
  }

  Future<void> _ucitajSazetak() async {
    final sviNapredci = await ProgressService.getAllProgress();
    final ukupno = sveTeme.fold<int>(0, (s, t) => s + t.bloomLessons.length);
    if (!mounted) return;
    setState(() {
      _zavrsenihLekcija = sviNapredci.where((p) => p.completed).length;
      _ukupnoLekcija = ukupno;
      _ucitavanje = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  BoxDecoration _glassDecoration() {
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

  String _formatirajDatum(String? isoDatum) {
    if (isoDatum == null) return '-';
    try {
      final d = DateTime.parse(isoDatum);
      const mjeseci = [
        'siječnja', 'veljače', 'ožujka', 'travnja', 'svibnja', 'lipnja',
        'srpnja', 'kolovoza', 'rujna', 'listopada', 'studenoga', 'prosinca',
      ];
      return '${d.day}. ${mjeseci[d.month - 1]} ${d.year}.';
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final email = user?.email ?? '-';
    final fullName = user?.userMetadata?['full_name'] as String? ?? '-';
    final datumRegistracije = _formatirajDatum(user?.createdAt);

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
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                20, kToolbarHeight + 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Osobni podaci ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _glassDecoration(),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryBlue.withOpacity(0.16),
                              primaryBlue.withOpacity(0.26),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.person,
                            color: primaryBlue, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(fullName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(email,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Član od $datumRegistracije',
                          style: const TextStyle(
                              fontSize: 12,
                              color: primaryBlueDark,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- Sažetak napretka ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: _glassDecoration(),
                  child: _ucitavanje
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Ukupan napredak',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$_zavrsenihLekcija od $_ukupnoLekcija lekcija završeno',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: _ukupnoLekcija > 0
                                        ? _zavrsenihLekcija / _ukupnoLekcija
                                        : 0,
                                    strokeWidth: 4,
                                    backgroundColor:
                                        primaryBlue.withOpacity(0.10),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            primaryBlue),
                                  ),
                                  Text(
                                    _ukupnoLekcija > 0
                                        ? '${((_zavrsenihLekcija / _ukupnoLekcija) * 100).round()}%'
                                        : '0%',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // --- Postavke ---
                Container(
                  decoration: _glassDecoration(),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.lock_reset,
                                  color: primaryBlue, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Promijeni lozinku',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Colors.black38, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Odjava ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Odjavi se',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.red.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}