import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/state.dart';
import 'core/theme.dart';
import 'l10n/ules_localizations.dart';

void main() {
  runApp(const ProviderScope(child: UlesApp()));
}

class UlesApp extends ConsumerWidget {
  const UlesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Ules',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: UlesTheme.light(),
      darkTheme: UlesTheme.dark(),
      locale: settings.locale,
      supportedLocales: UlesLocalizations.supportedLocales,
      localizationsDelegates: const [
        UlesLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
