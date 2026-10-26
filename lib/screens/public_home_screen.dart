import 'package:flutter/material.dart';

import '../data/public_flows.dart';
import '../data/referentiel.dart';
import '../widgets/common.dart';
import 'public_flow_screen.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Oncoscope')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Quel cancer vous concerne ?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez le cancer qui vous a touché, ou qui a touché l’un de '
            'vos proches. Vous répondrez à quelques questions ; cela prend '
            'environ deux minutes.',
          ),
          const SizedBox(height: 14),
          const InfoBanner(
            'Une consultation d’oncogénétique sert à savoir si des cancers '
            'dans une famille peuvent avoir une cause héréditaire. C’est '
            'pendant cette consultation que l’on décide, avec vous, de faire '
            'ou non une analyse génétique (prise de sang ou de salive) : rien '
            'n’est décidé avant.',
          ),
          for (final flow in publicFlows)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: Icon(
                  Referentiel.pathologies
                      .firstWhere((p) => p.id == flow.pathologyId)
                      .icon,
                  color: scheme.primary,
                ),
                title: Text(flow.title),
                subtitle: Text(flow.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PublicFlowScreen(flow: flow),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Votre cancer ne figure pas dans la liste ? Cela ne veut pas dire '
            'qu’il n’y a pas de cause héréditaire : parlez-en à votre médecin.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
