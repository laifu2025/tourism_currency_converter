import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/settings_provider.dart';
import 'data/providers/favorites_provider.dart';
import 'pages/home_page.dart';
import 'pages/currencies_page.dart';
import 'pages/settings_page.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/widgets/breathing_background.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadDefaultCurrency()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const LocaleApp(),
    ),
  );
}

class LocaleApp extends StatefulWidget {
  const LocaleApp({Key? key}) : super(key: key);

  @override
  State<LocaleApp> createState() => _LocaleAppState();

  static _LocaleAppState? of(BuildContext context) => context.findAncestorStateOfType<_LocaleAppState>();
}

class _LocaleAppState extends State<LocaleApp> {
  Locale? _locale = const Locale('zh');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? '旅游货币转换器',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: MainTabPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;
  final _pages = const [
    HomePage(),
    CurrenciesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return BreathingBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.arrow_2_circlepath),
                      label: s.tabConverter),
                  BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.list_bullet),
                      label: s.tabCurrencies),
                  BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.settings),
                      label: s.tabSettings),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
