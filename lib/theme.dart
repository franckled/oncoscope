import 'package:flutter/material.dart';

import 'data/models.dart';

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0B5C7D),
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}

/// Couleur associée à un type de section (bleu = personnel, rose = familial,
/// comme dans le référentiel papier).
Color toneColor(SectionKind kind) {
  switch (kind) {
    case SectionKind.biological:
      return const Color(0xFF8E3FB5);
    case SectionKind.personalIsolated:
      return const Color(0xFF1E6FD9);
    case SectionKind.personalMulti:
      return const Color(0xFF0E8A9E);
    case SectionKind.theranostic:
      return const Color(0xFF2E9E5B);
    case SectionKind.familial:
      return const Color(0xFFD6336C);
    case SectionKind.clinical:
      return const Color(0xFF5B4BDB);
  }
}

IconData kindIcon(SectionKind kind) {
  switch (kind) {
    case SectionKind.biological:
      return Icons.biotech_outlined;
    case SectionKind.personalIsolated:
      return Icons.person_outline;
    case SectionKind.personalMulti:
      return Icons.people_outline;
    case SectionKind.theranostic:
      return Icons.medication_outlined;
    case SectionKind.familial:
      return Icons.family_restroom;
    case SectionKind.clinical:
      return Icons.medical_information_outlined;
  }
}

String kindLabel(SectionKind kind) {
  switch (kind) {
    case SectionKind.biological:
      return 'Tumeur';
    case SectionKind.personalIsolated:
      return 'Personnel';
    case SectionKind.personalMulti:
      return 'Personnel';
    case SectionKind.theranostic:
      return 'Théranostique';
    case SectionKind.familial:
      return 'Familial';
    case SectionKind.clinical:
      return 'Clinique';
  }
}
