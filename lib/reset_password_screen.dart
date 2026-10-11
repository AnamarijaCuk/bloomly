// lib/reset_password_screen.dart
//
// Prikazuje se automatski (preko main.dart) kad korisnik klikne na link za
// reset lozinke iz emaila.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/supabase_service.dart';
import 'home_screen.dart';
import 'widgets/app_background.dart';
import 'widgets/glass_card.dart';

const Color _brand = Color(0xFF378ADD);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: Colors.black54),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF6F8FB),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _brand, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  Future<void> _postaviNovuLozinku() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lozinka je uspješno promijenjena!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Došlo je do greške. Pokušajte ponovno.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _brand.withOpacity(0.16),
                                _brand.withOpacity(0.26),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child:
                              const Icon(Icons.lock_reset, color: _brand, size: 30),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Postavi novu lozinku',
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Unesi novu lozinku za svoj račun',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: _decoration('Nova lozinka'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite novu lozinku';
                            }
                            if (value.length < 6) {
                              return 'Lozinka mora imati barem 6 znakova';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: _decoration('Potvrdi novu lozinku'),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Lozinke se ne podudaraju';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: _loading ? null : _postaviNovuLozinku,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brand,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Postavi lozinku'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}