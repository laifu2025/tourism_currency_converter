import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final listBackgroundColor = isDarkMode
        ? Colors.black.withOpacity(0.4)
        : Colors.grey.shade800.withOpacity(0.4);
    final textColor = Colors.white;

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: CustomScrollView(
        slivers: <Widget>[
           SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: theme.textTheme.headlineLarge?.copyWith(color: textColor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoListSection.insetGrouped(
                backgroundColor: listBackgroundColor,
                header: Text(
                  AppLocalizations.of(context)!.settingsAppearance,
                  style: theme.textTheme.titleSmall?.copyWith(color: textColor.withOpacity(0.6)),
                ),
                children: <Widget>[
                  _buildThemeSwitch(context, isDarkMode, textColor),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoListSection.insetGrouped(
                backgroundColor: listBackgroundColor,
                header: Text(
                  AppLocalizations.of(context)!.settingsAbout,
                  style: theme.textTheme.titleSmall?.copyWith(color: textColor.withOpacity(0.6)),
                ),
                children: <Widget>[
                  _buildAboutTile(context, textColor),
                ],
              ),
            ),
          ),
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 24),
              child: Center(
                child: Text(
                  '© 2024 Tourism Currency Converter',
                  style: theme.textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context, bool isDarkMode, Color textColor) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoListTile(
      title: Text(
        AppLocalizations.of(context)!.theme,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isDarkMode ? AppLocalizations.of(context)!.themeDark : AppLocalizations.of(context)!.themeLight,
             style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor.withOpacity(0.6)),
          ),
          const SizedBox(width: 8),
          CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context, Color textColor) {
    return CupertinoListTile(
      title: Text(
        AppLocalizations.of(context)!.aboutDataSource,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
      ),
      trailing: Icon(CupertinoIcons.chevron_forward, color: textColor.withOpacity(0.4)),
      onTap: () => _showAboutDialog(context),
    );
  }

  void _showAboutDialog(BuildContext context) {
    // Implementation of _showAboutDialog method
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: child,
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}