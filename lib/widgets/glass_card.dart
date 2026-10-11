// lib/widgets/glass_card.dart
//
// Zajednička "plutajuća" bijela kartica (bez obruba, meka sjena, zaobljeni
// rubovi) - koristi se za forme na auth ekranima (login, registracija,
// zaboravljena/nova lozinka) da izgledaju dosljedno s ostatkom aplikacije.

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  static const Color _brand = Color(0xFF378ADD);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _brand.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}