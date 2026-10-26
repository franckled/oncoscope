import 'package:flutter/material.dart';

import 'data/models.dart';

const Color kBrandTeal = Color(0xFF0E7C86);
const Color kBrandDeep = Color(0xFF0B4F6C);
const Color kBrandCoral = Color(0xFFE76F51);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: kBrandTeal,
    brightness: brightness,
  );
  final isLight = brightness == Brightness.light;
  final background = isLight ? const Color(0xFFF2F8F8) : scheme.surface;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: background,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isLight ? Colors.white : scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

/// Couleur d'identité de chaque cancer (assez foncée pour du texte blanc).
Color pathologyColor(String id) {
  switch (id) {
    case 'sein':
      return const Color(0xFFC2255C);
    case 'ovaire':
      return const Color(0xFF7B3FA0);
    case 'prostate':
      return const Color(0xFF1C5FBF);
    case 'pancreas':
      return const Color(0xFFC25E10);
    case 'colon':
      return const Color(0xFF7A4B2E);
    case 'endometre':
      return const Color(0xFF9C2F7D);
    case 'estomac':
      return const Color(0xFF2A7F4F);
    case 'polypose':
      return const Color(0xFF0B7285);
    case 'rein':
      return const Color(0xFFA52A2A);
    default:
      return kBrandTeal;
  }
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
