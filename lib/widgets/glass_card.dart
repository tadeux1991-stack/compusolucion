import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Efecto de desenfoque (Blur)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(),
            ),
            // Degradado de fondo y borde
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  width: 1.5,
                  color: Colors.white.withOpacity(0.1),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: child,
            ),
            // Brillo en el borde (Neon effect)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    width: 1.5,
                    color: AppTheme.neonCyan.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
