import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/app_background.dart';
import 'widgets/glass_card.dart';
import 'services/supabase_service.dart';
import 'home_screen.dart';

const Color _brand = Color(0xFF378ADD);

InputDecoration _modernInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 13, color: Colors.black54),
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF6F8FB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
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

Widget _modernIcon(IconData icon, {Color? bg, Color? fg}) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (bg ?? _brand).withOpacity(0.16),
          (bg ?? _brand).withOpacity(0.26),
        ],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Icon(icon, color: fg ?? _brand, size: 30),
  );
}

ButtonStyle _modernButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: _brand,
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}

// ===================== LOGIN =====================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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
          const SnackBar(content: Text('Došlo je do greške. Pokušajte ponovno.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _brand,
                                _brand.withOpacity(0.75),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _brand.withOpacity(0.30),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.filter_vintage_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'BLOOMLY',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _brand,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Prijavite se',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 14),
                          decoration: _modernInputDecoration('Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite email';
                            }
                            if (!value.contains('@')) {
                              return 'Unesite ispravan email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: _modernInputDecoration('Lozinka'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite lozinku';
                            }
                            if (value.length < 6) {
                              return 'Lozinka mora imati barem 6 znakova';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              'Zaboravljena lozinka?',
                              style: TextStyle(fontSize: 12, color: _brand),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: _modernButtonStyle(),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Prijavi se'),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                              children: [
                                TextSpan(text: 'Nemaš račun? '),
                                TextSpan(
                                  text: 'Registriraj se',
                                  style: TextStyle(
                                    color: _brand,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

// ===================== REGISTER =====================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {'full_name': _nameController.text.trim()},
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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
          const SnackBar(content: Text('Došlo je do greške. Pokušajte ponovno.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _modernIcon(Icons.person_add_alt_1_rounded),
                        const SizedBox(height: 20),
                        const Text(
                          'Registracija',
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ispuni podatke za kreiranje računa',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: _modernInputDecoration('Ime i prezime'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite ime i prezime';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 14),
                          decoration: _modernInputDecoration('Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite email';
                            }
                            if (!value.contains('@')) {
                              return 'Unesite ispravan email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: _modernInputDecoration('Lozinka'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Unesite lozinku';
                            }
                            if (value.length < 6) {
                              return 'Lozinka mora imati barem 6 znakova';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration:
                              _modernInputDecoration('Potvrdi lozinku'),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Lozinke se ne podudaraju';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: _modernButtonStyle(),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Registriraj se'),
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

// ===================== FORGOT PASSWORD =====================

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await supabase.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        redirectTo: Uri.base.origin,
      );
      if (mounted) setState(() => _sent = true);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Došlo je do greške. Pokušajte ponovno.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: GlassCard(
                  child: _sent
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _modernIcon(
                              Icons.mark_email_read_outlined,
                              bg: const Color(0xFF0F6E56),
                              fg: const Color(0xFF0F6E56),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Provjeri svoj email',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Poslali smo poveznicu za resetiranje lozinke na ${_emailController.text}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: _modernButtonStyle(),
                              child: const Text('Natrag na prijavu'),
                            ),
                          ],
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _modernIcon(Icons.lock_reset_outlined),
                              const SizedBox(height: 20),
                              const Text(
                                'Resetiraj lozinku',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Unesi email na koji ćemo poslati poveznicu za reset',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(fontSize: 14),
                                decoration: _modernInputDecoration('Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Unesite email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Unesite ispravan email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _loading ? null : _sendResetLink,
                                style: _modernButtonStyle(),
                                child: _loading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Pošalji poveznicu'),
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