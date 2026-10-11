// lib/widgets/app_background.dart
//
// Zajednička pozadina za cijelu aplikaciju - suptilan plavi gradijent s
// mekim "blob" oblicima za dubinu i modernu, premium atmosferu.

import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  static const Color _brand = Color(0xFF378ADD);
  static const Color _brandDark = Color(0xFF185FA5);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _brand.withOpacity(0.10),
                  Colors.white,
                  Colors.white,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -90,
          child: _Blob(size: 320, color: _brand.withOpacity(0.16)),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: _Blob(size: 360, color: _brandDark.withOpacity(0.10)),
        ),
        Positioned(
          top: 260,
          right: -60,
          child: _Blob(size: 160, color: _brand.withOpacity(0.10)),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}