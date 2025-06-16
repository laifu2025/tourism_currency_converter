import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/generated/app_localizations.dart';
import 'data/providers/theme_provider.dart';
import 'pages/home_page.dart';
import 'pages/currencies_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
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
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: s.tabConverter),
          BottomNavigationBarItem(icon: const Icon(Icons.list), label: s.tabCurrencies),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: s.tabSettings),
        ],
      ),
    );
  }
}
