import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme.dart';
import 'common.dart';

/// Évaluation d'un patient : l'utilisateur coche les critères présents,
/// l'écran indique si au moins un critère d'indication est rempli.
class CheckerView extends StatefulWidget {
  const CheckerView({super.key, required this.pathology});

  final Pathology pathology;

  @override
  State<CheckerView> createState() => _CheckerViewState();
}

class _CheckerViewState extends State<CheckerView>
    with AutomaticKeepAliveClientMixin {
  final Set<String> _selected = <String>{};

  @override
  bool get wantKeepAlive => true;

  String _key(int s, int c, [int? o]) => o == null ? '$s:$c' : '$s:$c:$o';

  void _toggle(String key, bool? value) {
    setState(() {
      if (value == true) {
        _selected.add(key);
      } else {
        _selected.remove(key);
      }
    });
  }

  bool _isMet(int s, int c) {
    final crit = widget.pathology.sections[s].criteria[c];
    if (!crit.hasOptions) {
      return _selected.contains(_key(s, c));
    }
    var count = 0;
    for (var o = 0; o < crit.options.length; o++) {
      if (_selected.contains(_key(s, c, o))) count++;
    }
    return count >= crit.minRequired;
  }

  /// Critères remplis, regroupés par section (index de section -> nombre).
  Map<int, int> _metBySection() {
    final result = <int, int>{};
    final sections = widget.pathology.sections;
    for (var s = 0; s < sections.length; s++) {
      var n = 0;
      for (var c = 0; c < sections[s].criteria.length; c++) {
        if (_isMet(s, c)) n++;
      }
      if (n > 0) result[s] = n;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final sections = widget.pathology.sections;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cochez les critères présents chez le patient.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => setState(_selected.clear),
                    icon: const Icon(Icons.restart_alt, size: 18),
                    label: const Text('Réinitialiser'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final note in widget.pathology.notes) InfoBanner(note),
              for (var s = 0; s < sections.length; s++) _buildSection(s),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _buildResult(context),
      ],
    );
  }

  Widget _buildSection(int s) {
    final section = widget.pathology.sections[s];
    final tone = toneColor(section.kind);
    final theme = Theme.of(context);

    return SectionFrame(
      kind: section.kind,
      title: section.title,
      children: [
        if (section.statement != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.block, size: 18, color: tone),
              const SizedBox(width: 8),
              Expanded(child: Text(section.statement!)),
            ],
          ),
        for (var c = 0; c < section.criteria.length; c++) ...[
          _buildCriterion(s, c, section.criteria[c], tone, theme),
        ],
        for (final f in section.footnotes) FootnoteText(f),
      ],
    );
  }

  Widget _buildCriterion(
    int s,
    int c,
    Criterion crit,
    Color tone,
    ThemeData theme,
  ) {
    if (!crit.hasOptions) {
      return CheckboxListTile(
        value: _selected.contains(_key(s, c)),
        onChanged: (v) => _toggle(_key(s, c), v),
        title: Text(crit.text),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        activeColor: tone,
      );
    }

    final met = _isMet(s, c);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.fromLTRB(10, 8, 6, 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: met ? tone : tone.withValues(alpha: 0.25),
          width: met ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  met ? Icons.check_circle : Icons.rule,
                  size: 18,
                  color: tone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  crit.text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26, top: 2),
            child: Text(
              crit.minRequired > 1
                  ? 'Cochez les éléments présents (au moins ${crit.minRequired} requis).'
                  : 'Cochez l’élément présent (l’énoncé ci-dessus doit être rempli).',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (var o = 0; o < crit.options.length; o++)
            CheckboxListTile(
              value: _selected.contains(_key(s, c, o)),
              onChanged: (v) => _toggle(_key(s, c, o), v),
              title: Text(crit.options[o]),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 16),
              dense: true,
              activeColor: tone,
            ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sections = widget.pathology.sections;
    final met = _metBySection();

    var theranosticMet = false;
    var otherMet = false;
    for (final s in met.keys) {
      if (sections[s].kind == SectionKind.theranostic) {
        theranosticMet = true;
      } else {
        otherMet = true;
      }
    }

    final Color background;
    final Color foreground;
    final IconData icon;
    final String headline;
    final List<Widget> details = [];

    if (met.isEmpty && _selected.isEmpty) {
      background = scheme.surfaceContainerHighest;
      foreground = scheme.onSurfaceVariant;
      icon = Icons.touch_app_outlined;
      headline = 'Aucun critère coché pour l’instant';
    } else if (met.isEmpty) {
      background = scheme.surfaceContainerHighest;
      foreground = scheme.onSurface;
      icon = Icons.help_outline;
      headline = 'Aucun critère rempli';
      details.add(
        Text(
          'Pas d’indication de consultation selon ce tableau. Selon le '
          'contexte clinique ou en cas de doute, notamment face à des '
          'diagnostics tardifs, la demande peut être soumise à l’évaluation '
          'd’une équipe d’oncogénétique.',
          style: TextStyle(color: foreground),
        ),
      );
    } else {
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
      icon = Icons.check_circle_outline;
      headline = otherMet
          ? 'Consultation d’oncogénétique indiquée'
          : 'Situation théranostique';
      for (final entry in met.entries) {
        final section = sections[entry.key];
        details.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '• ${section.title} : ${entry.value} critère(s) rempli(s)',
              style: TextStyle(color: foreground),
            ),
          ),
        );
      }
      if (otherMet) {
        details.add(
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'L’indication d’une analyse génétique sera posée en consultation '
              '(informativité de l’histoire familiale, souhait du patient).',
              style: TextStyle(color: foreground),
            ),
          ),
        );
      }
      if (theranosticMet) {
        details.add(
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Demande à visée théranostique : elle peut être adressée '
              'directement à l’équipe d’oncogénétique.',
              style: TextStyle(color: foreground),
            ),
          ),
        );
      }
    }

    return Material(
      elevation: 8,
      color: background,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.38,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: foreground),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        headline,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (details.isNotEmpty) const SizedBox(height: 8),
                ...details,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
