import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/referentiel.dart';
import '../widgets/common.dart';

/// Ouvre l'annexe [number] si elle existe.
void openAnnexe(BuildContext context, int number) {
  final annexe = Referentiel.annexe(number);
  if (annexe == null) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => AnnexeScreen(annexe: annexe)),
  );
}

class AnnexeScreen extends StatelessWidget {
  const AnnexeScreen({super.key, required this.annexe});

  final Annexe annexe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Annexe ${annexe.number}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            annexe.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          for (final block in annexe.blocks) _buildBlock(context, block),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBlock(BuildContext context, AnnexeBlock block) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (block is ParagraphBlock) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          block.text,
          style: block.emphasis
              ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
              : theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
        ),
      );
    }

    if (block is BulletsBlock) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  block.title!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ..._itemWidgets(block.items),
          ],
        ),
      );
    }

    if (block is LabeledBlock) {
      return Column(
        children: [
          for (final row in block.rows)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                  if (row.intro != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(row.intro!),
                    ),
                  const SizedBox(height: 6),
                  ..._joinedItems(row),
                ],
              ),
            ),
        ],
      );
    }

    if (block is TwoColsBlock) {
      return Column(
        children: [
          _ColumnCard(title: block.leftTitle, items: block.left),
          _ColumnCard(title: block.rightTitle, items: block.right),
        ],
      );
    }

    if (block is ImageBlock) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block.caption,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _ImageViewer(
                    asset: block.asset,
                    title: 'Annexe ${annexe.number}',
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  block.asset,
                  fit: BoxFit.contain,
                  semanticLabel: block.caption,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Appuyer sur l’image pour l’agrandir.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  List<Widget> _itemWidgets(List<Item> items) {
    final out = <Widget>[];
    for (final item in items) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BulletText(item.text),
              for (final sub in item.subs)
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('–'),
                      ),
                      Expanded(child: Text(sub)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return out;
  }

  List<Widget> _joinedItems(LabeledRow row) {
    final out = <Widget>[];
    for (var i = 0; i < row.items.length; i++) {
      if (i > 0 && row.joiner != null) {
        out.add(
          Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 4),
            child: Text(
              row.joiner!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      }
      out.addAll(_itemWidgets([row.items[i]]));
    }
    return out;
  }
}

class _ColumnCard extends StatelessWidget {
  const _ColumnCard({required this.title, required this.items});

  final String title;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BulletText(item.text),
                  for (final sub in item.subs)
                    Padding(
                      padding: const EdgeInsets.only(left: 22, top: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text('–'),
                          ),
                          Expanded(child: Text(sub)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      backgroundColor: Colors.white,
      body: InteractiveViewer(
        minScale: 0.8,
        maxScale: 5,
        child: Center(child: Image.asset(asset, fit: BoxFit.contain)),
      ),
    );
  }
}
