import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oncoscope/data/models.dart';
import 'package:oncoscope/data/public_flows.dart';
import 'package:oncoscope/data/referentiel.dart';
import 'package:oncoscope/screens/public_flow_screen.dart';
import 'package:oncoscope/screens/search_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('le référentiel contient 9 pathologies et 8 annexes', () {
    expect(Referentiel.pathologies.length, 9);
    expect(Referentiel.annexes.length, 8);
    for (var i = 0; i < Referentiel.annexes.length; i++) {
      expect(Referentiel.annexes[i].number, i + 1);
    }
  });

  test('chaque section a des critères ou un énoncé', () {
    for (final p in Referentiel.pathologies) {
      expect(p.sections, isNotEmpty, reason: p.name);
      for (final s in p.sections) {
        expect(s.hasCriteria || s.statement != null, isTrue,
            reason: '${p.name} › ${s.title}');
      }
    }
  });

  test('toutes les annexes citées existent', () {
    for (final p in Referentiel.pathologies) {
      for (final s in p.sections) {
        for (final c in s.criteria) {
          for (final n in c.annexes) {
            expect(Referentiel.annexe(n), isNotNull,
                reason: 'Annexe $n citée dans ${p.name}');
          }
        }
      }
    }
  });

  test('les critères composés ont un seuil cohérent', () {
    for (final p in Referentiel.pathologies) {
      for (final s in p.sections) {
        for (final c in s.criteria) {
          if (c.hasOptions) {
            expect(c.minRequired, lessThanOrEqualTo(c.options.length));
          }
        }
      }
    }
  });

  test('les images des annexes sont chargeables', () async {
    for (final a in Referentiel.annexes) {
      for (final b in a.blocks) {
        if (b is ImageBlock) {
          final data = await rootBundle.load(b.asset);
          expect(data.lengthInBytes, greaterThan(0), reason: b.asset);
        }
      }
    }
  });

  test('la recherche ignore accents et casse', () {
    expect(normalizeText('Phénotype dMMR ÉNDOMÈTRE’'),
        'phenotype dmmr endometre\'');
  });

  test('chaque pathologie a un questionnaire grand public', () {
    for (final p in Referentiel.pathologies) {
      expect(publicFlowFor(p.id), isNotNull, reason: p.name);
    }
  });

  test('chaque critère du référentiel est couvert par une question publique',
      () {
    for (final p in Referentiel.pathologies) {
      final flow = publicFlowFor(p.id)!;
      final covered = <String>{
        for (final q in flow.questions) ...q.covers,
      };
      for (final s in p.sections) {
        for (final c in s.criteria) {
          expect(covered.contains(c.text), isTrue,
              reason: '${p.name}: « ${c.text} » non couvert');
        }
      }
    }
  });

  test('les identifiants de questions sont uniques', () {
    final ids = <String>{};
    for (final f in publicFlows) {
      for (final q in f.questions) {
        expect(ids.add(q.id), isTrue, reason: q.id);
      }
    }
  });

  test('résultat : un « oui » personnel suffit', () {
    final flow = publicFlowFor('sein')!;
    final out = computeOutcome(flow, {'sein-1': Answer.yes}, {});
    expect(out.personalOrFamilyMet, isTrue);
    expect(out.teamMet, isFalse);
  });

  test('résultat : une liste exige le seuil de cases cochées', () {
    final flow = publicFlowFor('polypose')!;
    final one = computeOutcome(flow, {'polypose-2': Answer.yes}, {
      'polypose-2': {0},
    });
    expect(one.anyMet, isFalse);
    final two = computeOutcome(flow, {'polypose-2': Answer.yes}, {
      'polypose-2': {0, 3},
    });
    expect(two.anyMet, isTrue);
  });

  test('résultat : « je ne sais pas » ne déclenche rien', () {
    final flow = publicFlowFor('sein')!;
    final out = computeOutcome(flow, {'sein-1': Answer.unknown}, {});
    expect(out.anyMet, isFalse);
    expect(out.unknownCount, 1);
  });

  test('résultat : une question « équipe » est signalée à part', () {
    final flow = publicFlowFor('prostate')!;
    final out = computeOutcome(flow, {'prostate-thera': Answer.yes}, {});
    expect(out.teamMet, isTrue);
    expect(out.personalOrFamilyMet, isFalse);
  });
}
