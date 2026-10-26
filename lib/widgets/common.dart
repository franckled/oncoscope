import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../screens/annexe_screen.dart';
import '../theme.dart';

/// Puce + texte.
class BulletText extends StatelessWidget {
  const BulletText(this.text, {super.key, this.color, this.style});

  final String text;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final dot = color ?? Theme.of(context).colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 10, left: 2),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
        ),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}

/// Cadre coloré avec un titre, utilisé pour chaque section d'un tableau.
class SectionFrame extends StatelessWidget {
  const SectionFrame({
    super.key,
    required this.kind,
    required this.title,
    required this.children,
  });

  final SectionKind kind;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tone = toneColor(kind);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tone.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.16),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(kindIcon(kind), size: 18, color: tone),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

/// Puces cliquables vers les annexes citées.
class AnnexeChips extends StatelessWidget {
  const AnnexeChips(this.numbers, {super.key});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    if (numbers.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 18),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final n in numbers)
            ActionChip(
              avatar: const Icon(Icons.menu_book_outlined, size: 16),
              label: Text('Annexe $n'),
              visualDensity: VisualDensity.compact,
              onPressed: () => openAnnexe(context, n),
            ),
        ],
      ),
    );
  }
}

/// Bandeau d'information (notes, remarques).
class InfoBanner extends StatelessWidget {
  const InfoBanner(this.text, {super.key, this.icon = Icons.info_outline});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// Texte de note de bas de tableau.
class FootnoteText extends StatelessWidget {
  const FootnoteText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Copie [text] dans le presse-papiers et le confirme à l'écran.
Future<void> copyText(BuildContext context, String text, String message) async {
  final messenger = ScaffoldMessenger.of(context);
  await Clipboard.setData(ClipboardData(text: text));
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
