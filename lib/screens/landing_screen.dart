import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/hero.dart';
import '../widgets/logo.dart';
import 'home_screen.dart';
import 'public_home_screen.dart';

/// Premier écran : choix du profil (grand public ou professionnel de santé).
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroHeader(
              padding: EdgeInsets.fromLTRB(24, top + 36, 24, 44),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const OncoLogo(size: 60, inverted: true),
                          const SizedBox(width: 14),
                          Text(
                            'Oncoscope',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Une consultation d’oncogénétique est-elle utile '
                        'pour vous, ou pour votre patient ?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Répondez à quelques questions : l’outil vous '
                        'indique s’il est opportun d’en parler à un médecin.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qui êtes-vous ?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ProfileCard(
                        icon: Icons.person_outline,
                        colors: const [Color(0xFFF08A5D), kBrandCoral],
                        title: 'Je suis un particulier',
                        text:
                            'Quelques questions simples sur vous et votre famille.',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PublicHomeScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ProfileCard(
                        icon: Icons.medical_services_outlined,
                        colors: const [kBrandTeal, kBrandDeep],
                        title: 'Je suis un professionnel de santé',
                        text:
                            'Critères détaillés par pathologie, annexes et recherche.',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomeScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Pill(Icons.lock_outline, 'Aucune donnée collectée'),
                          _Pill(Icons.person_off_outlined, 'Sans compte'),
                          _Pill(Icons.verified_outlined,
                              'Fondé sur un référentiel'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Oncoscope est un outil d’aide à l’orientation. Il '
                        'ne pose aucun diagnostic et ne remplace pas un '
                        'médecin. Vos réponses restent sur votre appareil.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.icon,
    required this.colors,
    required this.title,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final List<Color> colors;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
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
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.onPrimaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
