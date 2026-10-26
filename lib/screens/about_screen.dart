import 'package:flutter/material.dart';

import '../data/referentiel.dart';
import '../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget title(String text) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        );

    Widget paragraph(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(text),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          InfoBanner(
            'Application non officielle, réalisée à partir du référentiel '
            'ci-dessous. Elle aide à l’orientation vers une consultation '
            'd’oncogénétique ; elle ne remplace ni le jugement clinique ni '
            'l’avis de l’équipe d’oncogénétique. Vérifiez que la version du '
            'référentiel reste en vigueur.',
            icon: Icons.warning_amber_outlined,
          ),
          title('Source'),
          paragraph(kSourceTitle),
          paragraph('$kSourceVersion\n$kSourceValidity'),
          title('Objet'),
          for (final t in kObjet) paragraph(t),
          title('Vocabulaire'),
          for (final t in kVocabulaire) paragraph(t),
        ],
      ),
    );
  }
}
