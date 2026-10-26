# Oncoscope

Application Flutter hors ligne qui aide à savoir si une **consultation
d'oncogénétique** est utile, pour un particulier ou pour un professionnel de santé.
Elle repose sur un référentiel d'indications de consultations d'oncogénétique
(version 1.0, octobre 2025).

Outil d'aide à l'orientation, **non officiel** : il ne pose aucun diagnostic et ne
remplace ni un médecin ni une équipe d'oncogénétique. Aucune donnée n'est collectée ni
envoyée : les réponses restent sur l'appareil.

## Deux parcours

- **Grand public** : choix du cancer, puis questions en langage courant (vous, votre
  famille, votre tumeur). Le résultat indique si une consultation est à envisager et
  rappelle que l'analyse génétique est décidée pendant la consultation, jamais avant.
- **Professionnels** : fiches détaillées par pathologie (sein, ovaire, prostate,
  pancréas, côlon, endomètre, estomac, polypose, rein), mode « évaluer un patient »,
  8 annexes, recherche tolérante aux accents.

## Démarrer

Le dépôt contient le code (`lib/`), les tests (`test/`) et les images (`assets/`),
mais pas les dossiers de plateforme. Une seule fois :

```bash
flutter create --project-name oncoscope --platforms=android,ios,web .
flutter pub get
flutter run
```

`flutter create .` ne touche pas à `lib/` ni à `pubspec.yaml`.

## Contenu

- `lib/data/referentiel.dart` : critères professionnels (source de vérité).
- `lib/data/public_flows.dart` : questions grand public. Chaque question déclare les
  critères qu'elle couvre ; un test vérifie qu'aucun critère n'est oublié.

**Les questions grand public sont des reformulations : elles doivent être relues par
une équipe d'oncogénétique avant toute diffusion publique.**

## Intégration continue

`.github/workflows/ci.yml` génère les plateformes, lance `flutter analyze` et
`flutter test`, puis produit un build web et un APK.
