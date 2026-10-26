import 'package:flutter/material.dart';

import '../theme.dart';
import 'logo.dart';

/// Bandeau en dégradé, avec une hélice en filigrane.
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 28),
    this.colors = const [kBrandTeal, kBrandDeep],
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -30,
              child: Opacity(
                opacity: 0.16,
                child: SizedBox(
                  width: 170,
                  height: 250,
                  child: CustomPaint(
                    painter: HelixPainter(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

/// Hauteur à réserver en haut d'un bandeau placé sous une barre
/// d'application transparente.
double heroTopInset(BuildContext context) =>
    MediaQuery.of(context).padding.top + kToolbarHeight + 4;
