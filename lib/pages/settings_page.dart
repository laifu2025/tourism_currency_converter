import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'package:tourism_currency_converter/pages/currencies_page.dart';
import '../main.dart';
import '../data/providers/theme_provider.dart';
import '../data/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _showAbout(BuildContext context, AppLocalizations s) {
    showAboutDialog(
      context: context,
      applicationName: s.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(),
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            children: [
              TextSpan(text: '${s.dataSourceInfo}\n\n'),
              TextSpan(
                text: 'currency-api',
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse('https://github.com/fawazahmed0/currency-api#readme'));
                  },
              ),
              const TextSpan(text: '.\n\n'),
              TextSpan(text: s.dataUpdateInfo),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroup(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 38.0, bottom: 8.0, top: 24.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    Locale currentLocale = Localizations.localeOf(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = context.watch<SettingsProvider>();

    ThemeMode currentMode = themeProvider.themeMode;
    String modeString;
    if (currentMode == ThemeMode.light) {
      modeString = s.appearanceLight;
    } else if (currentMode == ThemeMode.dark) {
      modeString = s.appearanceDark;
    } else {
      modeString = s.appearanceSystem;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 16.0),
              child: Text(
                s.settingsTitle,
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildGroup(
                    context,
                    title: s.settingsCategoryGeneral,
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.money_dollar_circle, color: Colors.white70),
                        title: Text(s.defaultCurrency, style: const TextStyle(color: Colors.white)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (settingsProvider.defaultCurrency ?? s.notSet).toUpperCase(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.chevron_right, color: Colors.white30),
                          ],
                        ),
                        onTap: () async {
                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(builder: (context) => const CurrenciesPage(isForSelection: true)),
                          );
                          if (result != null && context.mounted) {
                            context.read<SettingsProvider>().setDefaultCurrency(result);
                          }
                        },
                      ),
                      const Divider(indent: 56),
                      ListTile(
                        leading: const Icon(CupertinoIcons.globe, color: Colors.white70),
                        title: Text(s.language, style: const TextStyle(color: Colors.white)),
                        trailing: DropdownButton<Locale>(
                          value: currentLocale,
                          icon: const Icon(CupertinoIcons.chevron_down, color: Colors.white30),
                          dropdownColor: Colors.black.withOpacity(0.8),
                          style: const TextStyle(color: Colors.white70),
                          underline: Container(),
                          items: const [
                            DropdownMenuItem(value: Locale('zh'), child: Text('简体中文')),
                            DropdownMenuItem(value: Locale('en'), child: Text('English')),
                          ],
                          onChanged: (locale) {
                            if (locale != null) {
                              LocaleApp.of(context)?.setLocale(locale);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildGroup(
                    context,
                    title: s.settingsCategoryAppearance,
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.sun_max, color: Colors.white70),
                        title: Text(s.appearance, style: const TextStyle(color: Colors.white)),
                        trailing: DropdownButton<String>(
                          value: modeString,
                          icon: const Icon(CupertinoIcons.chevron_down, color: Colors.white30),
                          dropdownColor: Colors.black.withOpacity(0.8),
                          style: const TextStyle(color: Colors.white70),
                          underline: Container(),
                          items: [
                            DropdownMenuItem(value: s.appearanceSystem, child: Text(s.appearanceSystem)),
                            DropdownMenuItem(value: s.appearanceLight, child: Text(s.appearanceLight)),
                            DropdownMenuItem(value: s.appearanceDark, child: Text(s.appearanceDark)),
                          ],
                          onChanged: (v) {
                            if (v == s.appearanceSystem) {
                              themeProvider.setThemeMode(ThemeMode.system);
                            } else if (v == s.appearanceLight) {
                              themeProvider.setThemeMode(ThemeMode.light);
                            } else if (v == s.appearanceDark) {
                              themeProvider.setThemeMode(ThemeMode.dark);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildGroup(
                    context,
                    title: s.settingsCategoryAbout,
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.info_circle, color: Colors.white70),
                        title: Text(s.about, style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.white30),
                        onTap: () {
                          _showAbout(context, s);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(child: Text('${s.version} 1.0.0+1\n© 2024 ${s.appTitle}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white30, fontSize: 12))),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
