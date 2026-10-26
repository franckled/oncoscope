import 'package:flutter/material.dart';

import '../data/public_flows.dart';
import '../data/referentiel.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';
import 'public_flow_screen.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HeroHeader(
            colors: const [Color(0xFFF08A5D), kBrandCoral, Color(0xFFC8553D)],
            padding: EdgeInsets.fromLTRB(20, heroTopInset(context), 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quel cancer vous concerne ?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choisissez le cancer qui vous a touché, ou qui a touché '
                  'l’un de vos proches. Environ deux minutes.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoBanner(
                  'Une consultation d’oncogénétique sert à savoir si des '
                  'cancers dans une famille peuvent avoir une cause '
                  'héréditaire. C’est pendant cette consultation que l’on '
                  'décide, avec vous, de faire ou non une analyse génétique '
                  '(prise de sang ou de salive) : rien n’est décidé avant.',
                ),
                const SizedBox(height: 4),
                for (final flow in publicFlows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        leading: PathologyTile(
                          id: flow.pathologyId,
                          icon: Referentiel.pathologies
                              .firstWhere((p) => p.id == flow.pathologyId)
                              .icon,
                        ),
                        title: Text(
                          flow.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(flow.subtitle),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PublicFlowScreen(flow: flow),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  'Votre cancer ne figure pas dans la liste ? Cela ne veut '
                  'pas dire qu’il n’y a pas de cause héréditaire : parlez-en '
                  'à votre médecin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
