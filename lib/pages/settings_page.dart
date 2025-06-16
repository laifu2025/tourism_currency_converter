import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'package:tourism_currency_converter/pages/currencies_page.dart';
import 'package:url_launcher/url_launcher.dart';
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
            style: Theme.of(context).textTheme.bodyMedium,
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
      appBar: AppBar(
        title: Text(s.settingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.money),
            title: Text(s.defaultCurrency),
            trailing: Text(settingsProvider.defaultCurrency ?? s.notSet),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(s.appearance),
            trailing: DropdownButton<String>(
              value: modeString,
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(s.language),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(s.about),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showAbout(context, s);
            },
          ),
          const SizedBox(height: 32),
          Center(child: Text('${s.version} 1.0.0\n© 2024 ${s.appTitle}', style: const TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}
