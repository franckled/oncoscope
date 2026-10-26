import 'package:flutter/material.dart';

import '../data/public_flows.dart';

/// Résultat calculé à partir des réponses du questionnaire.
class PublicOutcome {
  const PublicOutcome({
    required this.personalOrFamilyMet,
    required this.teamMet,
    required this.unknownCount,
    required this.answeredCount,
  });

  /// Au moins une question « vous / famille » est remplie.
  final bool personalOrFamilyMet;

  /// Au moins une question « équipe soignante » (analyse de la tumeur,
  /// traitement ciblé) est remplie.
  final bool teamMet;
  final int unknownCount;
  final int answeredCount;

  bool get anyMet => personalOrFamilyMet || teamMet;
}

/// Calcule le résultat. [answers] : réponse par id de question ;
/// [checks] : cases cochées pour les questions à liste, par id.
PublicOutcome computeOutcome(
  PublicFlow flow,
  Map<String, Answer> answers,
  Map<String, Set<int>> checks,
) {
  var personalOrFamily = false;
  var team = false;
  var unknown = 0;
  var answered = 0;

  for (final q in flow.questions) {
    final a = answers[q.id];
    if (a != null) answered++;
    if (a == Answer.unknown) unknown++;

    final bool met;
    if (q.isChecklist) {
      // Il faut répondre « oui » à la question d'introduction et atteindre
      // le seuil de cases cochées.
      final count = (checks[q.id] ?? const <int>{}).length;
      met = a == Answer.yes && count >= q.minRequired;
    } else {
      met = a == Answer.yes;
    }
    if (met) {
      if (q.scope == PublicScope.team) {
        team = true;
      } else {
        personalOrFamily = true;
      }
    }
  }
  return PublicOutcome(
    personalOrFamilyMet: personalOrFamily,
    teamMet: team,
    unknownCount: unknown,
    answeredCount: answered,
  );
}

class PublicFlowScreen extends StatefulWidget {
  const PublicFlowScreen({super.key, required this.flow});

  final PublicFlow flow;

  @override
  State<PublicFlowScreen> createState() => _PublicFlowScreenState();
}

class _PublicFlowScreenState extends State<PublicFlowScreen> {
  final Map<String, Answer> _answers = {};
  final Map<String, Set<int>> _checks = {};
  bool _showResult = false;

  PublicFlow get flow => widget.flow;

  void _set(String id, Answer a) {
    setState(() {
      _answers[id] = a;
      _showResult = false;
    });
  }

  void _toggleCheck(String id, int index, bool? value) {
    setState(() {
      final set = _checks.putIfAbsent(id, () => <int>{});
      if (value == true) {
        set.add(index);
      } else {
        set.remove(index);
      }
      _showResult = false;
    });
  }

  List<PublicQuestion> _of(PublicScope scope) =>
      flow.questions.where((q) => q.scope == scope).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final allAnswered = _answers.length == flow.questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(flow.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Répondez par « Oui », « Non » ou « Je ne sais pas ». '
            'Si vous hésitez, choisissez « Je ne sais pas » : le résultat '
            'vous le signalera.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final note in flow.notes)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                note,
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            ),
          ..._group('Vous', Icons.person_outline, _of(PublicScope.you)),
          ..._group(
            'Votre famille',
            Icons.family_restroom,
            _of(PublicScope.family),
          ),
          ..._group(
            'Votre tumeur et votre traitement',
            Icons.medical_information_outlined,
            _of(PublicScope.team),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _answers.isEmpty
                ? null
                : () => setState(() => _showResult = true),
            icon: const Icon(Icons.fact_check_outlined),
            label: Text(allAnswered
                ? 'Voir mon résultat'
                : 'Voir mon résultat (réponses incomplètes)'),
          ),
          if (_showResult) ...[
            const SizedBox(height: 16),
            _ResultCard(
              outcome: computeOutcome(flow, _answers, _checks),
              totalQuestions: flow.questions.length,
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<Widget> _group(String title, IconData icon, List<PublicQuestion> qs) {
    if (qs.isEmpty) return const [];
    final theme = Theme.of(context);
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      for (final q in qs) _QuestionCard(
        question: q,
        answer: _answers[q.id],
        checks: _checks[q.id] ?? const <int>{},
        onAnswer: (a) => _set(q.id, a),
        onCheck: (i, v) => _toggleCheck(q.id, i, v),
      ),
    ];
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.answer,
    required this.checks,
    required this.onAnswer,
    required this.onCheck,
  });

  final PublicQuestion question;
  final Answer? answer;
  final Set<int> checks;
  final ValueChanged<Answer> onAnswer;
  final void Function(int index, bool? value) onCheck;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: theme.textTheme.bodyLarge),
            if (question.help != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        question.help!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            SegmentedButton<Answer>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: Answer.yes, label: Text('Oui')),
                ButtonSegment(value: Answer.no, label: Text('Non')),
                ButtonSegment(
                  value: Answer.unknown,
                  label: Text('Je ne sais pas'),
                ),
              ],
              selected: answer == null ? <Answer>{} : {answer!},
              onSelectionChanged: (s) {
                if (s.isNotEmpty) onAnswer(s.first);
              },
            ),
            if (question.isChecklist && answer == Answer.yes) ...[
              const SizedBox(height: 8),
              Text(
                question.minRequired > 1
                    ? 'Cochez ce qui vous concerne (au moins ${question.minRequired}) :'
                    : 'Cochez ce qui vous concerne :',
                style: theme.textTheme.labelLarge,
              ),
              for (var i = 0; i < question.options.length; i++)
                CheckboxListTile(
                  value: checks.contains(i),
                  onChanged: (v) => onCheck(i, v),
                  title: Text(question.options[i]),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.outcome, required this.totalQuestions});

  final PublicOutcome outcome;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Color bg;
    final Color fg;
    final IconData icon;
    final String headline;
    final List<String> lines = [];

    if (outcome.anyMet) {
      bg = scheme.primaryContainer;
      fg = scheme.onPrimaryContainer;
      icon = Icons.check_circle_outline;
      headline = 'Une consultation d’oncogénétique est à envisager';
      if (outcome.personalOrFamilyMet) {
        lines.add(
          'Vos réponses correspondent à au moins une situation pour '
          'laquelle une consultation d’oncogénétique est recommandée.',
        );
      }
      if (outcome.teamMet) {
        lines.add(
          'Une réponse concerne votre tumeur ou votre traitement : parlez-en '
          'à l’équipe qui vous soigne, qui peut demander directement une '
          'analyse à visée thérapeutique.',
        );
      }
      lines.add(
        'Prochaine étape : parlez-en à votre médecin traitant ou à votre '
        'oncologue, qui pourra vous adresser à une consultation '
        'd’oncogénétique. Ce n’est pas une analyse : on y étudie votre '
        'histoire familiale.',
      );
      lines.add(
        'Une analyse génétique n’est jamais décidée à l’avance : c’est '
        'pendant la consultation qu’elle est proposée ou non, selon '
        'l’histoire de votre famille et selon votre souhait. Vous restez '
        'libre d’accepter ou de refuser.',
      );
    } else if (outcome.answeredCount == 0) {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurfaceVariant;
      icon = Icons.touch_app_outlined;
      headline = 'Répondez à au moins une question';
    } else {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurface;
      icon = Icons.info_outline;
      headline = outcome.unknownCount > 0
          ? 'Pas de critère rempli, mais des réponses manquent'
          : 'Pas de critère rempli selon ce questionnaire';
      lines.add(
        'D’après vos réponses, aucune situation recommandant une consultation '
        'd’oncogénétique n’est retrouvée.',
      );
      if (outcome.unknownCount > 0) {
        lines.add(
          'Vous avez répondu « Je ne sais pas » à ${outcome.unknownCount} '
          'question(s). Essayez de rassembler ces informations (compte rendu '
          'médical, échanges avec vos proches) et refaites le questionnaire.',
        );
      }
      lines.add(
        'Ce résultat ne signifie pas qu’il n’y a aucun risque : si vous '
        'avez un doute, si des cancers ont été diagnostiqués tard dans votre '
        'famille ou si l’histoire familiale est mal connue, parlez-en à '
        'votre médecin.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: fg),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  headline,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(l, style: TextStyle(color: fg)),
            ),
          const SizedBox(height: 12),
          Text(
            'Cet outil est une aide à l’orientation. Il ne remplace pas '
            'l’avis d’un médecin ou d’une équipe d’oncogénétique.',
            style: theme.textTheme.bodySmall?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
