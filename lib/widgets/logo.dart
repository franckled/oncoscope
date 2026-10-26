import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Dessine une double hélice (ADN) stylisée dans [rect].
void paintHelix(
  Canvas canvas,
  Rect rect, {
  required Color strand1,
  required Color strand2,
  required Color rungs,
  required double stroke,
  int rungCount = 7,
  double turns = 1.25,
}) {
  const steps = 48;
  final cx = rect.center.dx;
  final amp = rect.width / 2 - stroke;

  double xAt(double t, double sign) =>
      cx + sign * amp * math.sin(t * 2 * math.pi * turns);

  final p1 = Path();
  final p2 = Path();
  for (var i = 0; i <= steps; i++) {
    final t = i / steps;
    final y = rect.top + rect.height * t;
    if (i == 0) {
      p1.moveTo(xAt(t, 1), y);
      p2.moveTo(xAt(t, -1), y);
    } else {
      p1.lineTo(xAt(t, 1), y);
      p2.lineTo(xAt(t, -1), y);
    }
  }

  final rungPaint = Paint()
    ..color = rungs
    ..strokeWidth = stroke * 0.55
    ..strokeCap = StrokeCap.round;
  for (var k = 0; k < rungCount; k++) {
    final t = (k + 0.5) / rungCount;
    final y = rect.top + rect.height * t;
    canvas.drawLine(Offset(xAt(t, 1), y), Offset(xAt(t, -1), y), rungPaint);
  }

  final strandPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  strandPaint.color = strand2;
  canvas.drawPath(p2, strandPaint);
  strandPaint.color = strand1;
  canvas.drawPath(p1, strandPaint);
}

/// Logo d'Oncoscope : une double hélice dans une pastille, avec un point
/// corail (le « repère » que l'on cherche dans une famille).
class OncoLogo extends StatelessWidget {
  const OncoLogo({super.key, this.size = 64, this.inverted = false});

  final double size;

  /// Pastille blanche et hélice colorée, pour les fonds foncés.
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo Oncoscope',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _LogoPainter(inverted: inverted)),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.inverted});

  final bool inverted;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final tile = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(w * 0.3),
    );

    final bg = Paint();
    if (inverted) {
      bg.color = Colors.white;
    } else {
      bg.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF18A3A8), Color(0xFF0B4F6C)],
      ).createShader(Offset.zero & size);
    }
    canvas.drawRRect(tile, bg);

    paintHelix(
      canvas,
      Rect.fromLTWH(w * 0.29, h * 0.17, w * 0.42, h * 0.66),
      strand1: inverted ? const Color(0xFF0E7C86) : Colors.white,
      strand2: const Color(0xFFE76F51),
      rungs: inverted
          ? const Color(0xFF0E7C86).withValues(alpha: 0.45)
          : Colors.white.withValues(alpha: 0.6),
      stroke: w * 0.075,
    );

    final dot = Paint()..color = const Color(0xFFE76F51);
    canvas.drawCircle(Offset(w * 0.80, h * 0.22), w * 0.065, dot);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.inverted != inverted;
}

/// Hélice décorative pour les bandeaux.
class HelixPainter extends CustomPainter {
  const HelixPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    paintHelix(
      canvas,
      Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height),
      strand1: color,
      strand2: color,
      rungs: color,
      stroke: size.width * 0.07,
      rungCount: 9,
      turns: 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant HelixPainter oldDelegate) =>
      oldDelegate.color != color;
}
