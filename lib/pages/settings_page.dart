import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/generated/app_localizations.dart';
import '../main.dart';
import '../data/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    Locale currentLocale = Localizations.localeOf(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            trailing: Text(s.aboutView),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Center(child: Text('${s.version} 1.0.0\n© 2024 ${s.appTitle}', style: const TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}
