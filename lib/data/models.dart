import 'package:flutter/widgets.dart';

/// Type de section d'un tableau récapitulatif du référentiel.
enum SectionKind {
  biological,
  personalIsolated,
  personalMulti,
  theranostic,
  familial,
  clinical,
}

/// Extrait les numéros d'annexes cités dans des textes ("cf. annexe 3").
List<int> annexeRefs(Iterable<String> texts) {
  final re = RegExp(r'annexe\s+(\d+)', caseSensitive: false);
  final found = <int>{};
  for (final t in texts) {
    for (final m in re.allMatches(t)) {
      found.add(int.parse(m.group(1)!));
    }
  }
  final list = found.toList()..sort();
  return list;
}

/// Un critère d'indication.
///
/// Si [options] est vide, le critère est simple. Sinon, [text] est
/// l'énoncé commun ("... atteint de :") et chaque option est une
/// alternative ; il faut au moins [minRequired] options pour que le
/// critère soit rempli.
class Criterion {
  const Criterion(this.text, {this.options = const [], this.minRequired = 1});

  final String text;
  final List<String> options;
  final int minRequired;

  bool get hasOptions => options.isNotEmpty;

  List<int> get annexes => annexeRefs([text, ...options]);

  List<String> get allTexts => [text, ...options];
}

/// Un bloc du tableau récapitulatif d'une pathologie.
class CriteriaSection {
  const CriteriaSection({
    required this.kind,
    required this.title,
    this.criteria = const [],
    this.statement,
    this.footnotes = const [],
  });

  final SectionKind kind;
  final String title;
  final List<Criterion> criteria;

  /// Texte affiché lorsque la section ne comporte pas de critère
  /// (ex. "Pas de critères d'indication ... théranostique").
  final String? statement;
  final List<String> footnotes;

  bool get hasCriteria => criteria.isNotEmpty;
}

class Pathology {
  const Pathology({
    required this.id,
    required this.name,
    required this.icon,
    required this.sections,
    this.notes = const [],
    this.references = const [],
  });

  final String id;
  final String name;
  final IconData icon;
  final List<CriteriaSection> sections;
  final List<String> notes;
  final List<String> references;

  int get criteriaCount {
    var n = 0;
    for (final s in sections) {
      n += s.criteria.length;
    }
    return n;
  }
}

// ---------------------------------------------------------------------------
// Annexes
// ---------------------------------------------------------------------------

/// Élément de liste, éventuellement avec des sous-éléments.
class Item {
  const Item(this.text, [this.subs = const []]);

  final String text;
  final List<String> subs;
}

abstract class AnnexeBlock {
  const AnnexeBlock();
}

class ParagraphBlock extends AnnexeBlock {
  const ParagraphBlock(this.text, {this.emphasis = false});

  final String text;
  final bool emphasis;
}

class BulletsBlock extends AnnexeBlock {
  const BulletsBlock(this.items, {this.title});

  final String? title;
  final List<Item> items;
}

class LabeledRow {
  const LabeledRow(this.label, this.items, {this.intro, this.joiner});

  final String label;
  final String? intro;

  /// Mot affiché entre les éléments (ex. "OU").
  final String? joiner;
  final List<Item> items;
}

class LabeledBlock extends AnnexeBlock {
  const LabeledBlock(this.rows);

  final List<LabeledRow> rows;
}

class TwoColsBlock extends AnnexeBlock {
  const TwoColsBlock(this.leftTitle, this.left, this.rightTitle, this.right);

  final String leftTitle;
  final List<Item> left;
  final String rightTitle;
  final List<Item> right;
}

class ImageBlock extends AnnexeBlock {
  const ImageBlock(this.asset, this.caption);

  final String asset;
  final String caption;
}

class Annexe {
  const Annexe({
    required this.number,
    required this.title,
    required this.blocks,
  });

  final int number;
  final String title;
  final List<AnnexeBlock> blocks;

  /// Tous les textes de l'annexe (utilisé par la recherche).
  List<String> get lines {
    final out = <String>[];
    void addItems(List<Item> items) {
      for (final i in items) {
        out.add(i.text);
        out.addAll(i.subs);
      }
    }

    for (final b in blocks) {
      if (b is ParagraphBlock) {
        out.add(b.text);
      } else if (b is BulletsBlock) {
        addItems(b.items);
      } else if (b is LabeledBlock) {
        for (final r in b.rows) {
          out.add(r.label);
          if (r.intro != null) out.add(r.intro!);
          addItems(r.items);
        }
      } else if (b is TwoColsBlock) {
        addItems(b.left);
        addItems(b.right);
      } else if (b is ImageBlock) {
        out.add(b.caption);
      }
    }
    return out;
  }
}
