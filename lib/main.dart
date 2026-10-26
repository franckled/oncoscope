import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/landing_screen.dart';
import 'theme.dart';

void main() {
  runApp(const OncoApp());
}

class OncoApp extends StatelessWidget {
  const OncoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oncoscope',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: const LandingScreen(),
    );
  }
}
