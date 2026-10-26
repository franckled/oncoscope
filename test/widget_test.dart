import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oncoscope/main.dart';

void main() {
  testWidgets('l’écran d’accueil propose les deux profils', (tester) async {
    await tester.pumpWidget(const OncoApp());
    await tester.pumpAndSettle();

    expect(find.text('Oncoscope'), findsOneWidget);
    expect(find.text('Je suis un particulier'), findsOneWidget);
    expect(find.text('Je suis un professionnel de santé'), findsOneWidget);
  });

  testWidgets('le parcours professionnel ouvre une fiche', (tester) async {
    await tester.pumpWidget(const OncoApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Je suis un professionnel de santé'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Je suis un professionnel de santé'));
    await tester.pumpAndSettle();

    // La tuile est déjà visible : ne pas la faire défiler sous la barre
    // d'application transparente.
    await tester.tap(find.text('Cancer du sein'));
    await tester.pumpAndSettle();

    expect(find.text('Cancer du sein isolé'), findsWidgets);
    expect(find.text('Évaluer un patient'), findsOneWidget);
  });

  testWidgets('le parcours grand public affiche un résultat', (tester) async {
    await tester.pumpWidget(const OncoApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Je suis un particulier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Je suis un particulier'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancer du sein'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Oui').first);
    await tester.pumpAndSettle();

    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.textContaining('Voir mon résultat'),
      400,
      scrollable: list,
    );
    await tester.tap(find.textContaining('Voir mon résultat'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('à envisager'),
      400,
      scrollable: list,
    );

    expect(find.textContaining('à envisager'), findsOneWidget);
  });
}
