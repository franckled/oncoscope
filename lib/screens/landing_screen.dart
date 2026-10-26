import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'public_home_screen.dart';

/// Premier écran : choix du profil (grand public ou professionnel de santé).
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget profileCard({
      required IconData icon,
      required String title,
      required String text,
      required VoidCallback onTap,
    }) {
      return Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 14),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Icon(icon, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(text),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                Icon(Icons.biotech_outlined, size: 48, color: scheme.primary),
                const SizedBox(height: 12),
                Text(
                  'Oncoscope',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Une consultation d’oncogénétique est-elle utile pour vous, '
                  'ou pour votre patient ?',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                profileCard(
                  icon: Icons.person_outline,
                  title: 'Je suis un particulier',
                  text:
                      'Quelques questions simples sur vous et votre famille.',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PublicHomeScreen(),
                    ),
                  ),
                ),
                profileCard(
                  icon: Icons.medical_services_outlined,
                  title: 'Je suis un professionnel de santé',
                  text:
                      'Critères détaillés par pathologie, annexes et recherche.',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Oncoscope est un outil d’aide à l’orientation. Il ne pose '
                  'aucun diagnostic, ne remplace pas un médecin et ne conserve '
                  'aucune de vos réponses : tout reste sur votre appareil.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
