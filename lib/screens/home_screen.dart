import 'package:flutter/material.dart';

import '../data/referentiel.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';
import 'about_screen.dart';
import 'annexe_screen.dart';
import 'pathology_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Rechercher',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            tooltip: 'À propos',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroHeader(
              padding: EdgeInsets.fromLTRB(20, heroTopInset(context), 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Espace professionnels',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ce patient relève-t-il d’une consultation '
                    'd’oncogénétique ?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consultez les critères par pathologie, ou évaluez un '
                    'patient en cochant les critères présents.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$kSourceTitle · $kSourceVersion',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _SectionTitle('Pathologies')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisExtent: 128,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = Referentiel.pathologies[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PathologyScreen(pathology: p),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PathologyTile(id: p.id, icon: p.icon, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: Referentiel.pathologies.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _SectionTitle('Annexes')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final a = Referentiel.annexes[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text('${a.number}'),
                  ),
                  title: Text(a.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openAnnexe(context, a.number),
                );
              },
              childCount: Referentiel.annexes.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Text(
                'Application non officielle, réalisée à partir du référentiel '
                'cité ci-dessus. Aide à l’orientation : elle ne remplace ni '
                'le jugement clinique ni l’avis d’une équipe d’oncogénétique.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
