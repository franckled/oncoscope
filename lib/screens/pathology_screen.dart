import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme.dart';
import '../widgets/checker_view.dart';
import '../widgets/common.dart';

class PathologyScreen extends StatelessWidget {
  const PathologyScreen({super.key, required this.pathology});

  final Pathology pathology;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pathology.name),
          backgroundColor: pathologyColor(pathology.id),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Critères'),
              Tab(icon: Icon(Icons.fact_check_outlined), text: 'Évaluer un patient'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CriteriaView(pathology: pathology),
            CheckerView(pathology: pathology),
          ],
        ),
      ),
    );
  }
}

class _CriteriaView extends StatelessWidget {
  const _CriteriaView({required this.pathology});

  final Pathology pathology;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final note in pathology.notes) InfoBanner(note),
        for (final section in pathology.sections)
          SectionFrame(
            kind: section.kind,
            title: section.title,
            children: [
              if (section.statement != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.block, size: 18, color: toneColor(section.kind)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(section.statement!)),
                  ],
                ),
              for (final c in section.criteria)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CriterionView(criterion: c, kind: section.kind),
                ),
              for (final f in section.footnotes) FootnoteText(f),
            ],
          ),
        if (pathology.references.isNotEmpty)
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text(
                'Références (${pathology.references.length})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final r in pathology.references)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: BulletText(r, style: theme.textTheme.bodySmall),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CriterionView extends StatelessWidget {
  const _CriterionView({required this.criterion, required this.kind});

  final Criterion criterion;
  final SectionKind kind;

  @override
  Widget build(BuildContext context) {
    final tone = toneColor(kind);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BulletText(criterion.text, color: tone),
        if (criterion.minRequired > 1)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 18),
            child: Text(
              'Au moins ${criterion.minRequired} des critères ci-dessous',
              style: theme.textTheme.labelMedium?.copyWith(
                color: tone,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (criterion.hasOptions)
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final o in criterion.options)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text('–', style: TextStyle(color: tone)),
                        ),
                        Expanded(child: Text(o)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        AnnexeChips(criterion.annexes),
      ],
    );
  }
}
