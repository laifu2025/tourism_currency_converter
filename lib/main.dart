import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'package:tourism_currency_converter/presentation/pages/webview_page.dart';
import 'package:tourism_currency_converter/core/services/app_config_service.dart';
import 'package:tourism_currency_converter/data/models/app_config.dart';
import 'package:tourism_currency_converter/data/providers/favorites_provider.dart';
import 'package:tourism_currency_converter/data/providers/settings_provider.dart';
import 'package:tourism_currency_converter/data/providers/theme_provider.dart';
import 'package:tourism_currency_converter/pages/home_page.dart';
import 'package:tourism_currency_converter/pages/settings_page.dart';
import 'package:tourism_currency_converter/pages/currencies_page.dart';
import 'package:tourism_currency_converter/presentation/themes/app_theme.dart';
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
  bool _isLoading = true;
  AppConfig? _appConfig;

  @override
  void initState() {
    super.initState();
    _fetchAppConfig();
  }

  Future<void> _fetchAppConfig() async {
    final appConfigService = AppConfigService();
    final config = await appConfigService.fetchAppConfig();
    setState(() {
      _appConfig = config;
      _isLoading = false;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_appConfig != null && _appConfig!.isRedirectEnabled && _appConfig!.redirectUrl != null) {
      return MaterialApp(
        home: WebViewPage(title: 'Redirect', url: _appConfig!.redirectUrl!, showAppBar: false),
        debugShowCheckedModeBanner: false,
      );
    }
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'TouristConverter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const MainTabPage(),
      routes: {
        '/currencies': (context) {
          final isForSelection = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
          return CurrenciesPage(isForSelection: isForSelection);
        },
      },
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
        appBar: null,
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
