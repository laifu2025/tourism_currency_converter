// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tourism Currency Converter';

  @override
  String get converterTitle => 'Currency Converter';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get inputAmount => 'Enter amount';

  @override
  String get defaultCurrency => 'Default Currency';

  @override
  String get notSet => 'Not Set';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSystem => 'System';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get aboutView => 'View';

  @override
  String get version => 'Version';

  @override
  String get searchCurrency => 'Search Currency';

  @override
  String get favorites => 'Favorites';

  @override
  String get allCurrencies => 'All Currencies';

  @override
  String get dataSourceInfo =>
      'The exchange rate data in this application is provided by the following service. The data is for reference only, and the actual transaction exchange rate is subject to the bank counter.';

  @override
  String get dataUpdateInfo => 'Exchange rate data is updated daily.';

  @override
  String get tabConverter => 'Converter';

  @override
  String get tabCurrencies => 'Currencies';

  @override
  String get tabSettings => 'Settings';

  @override
  String get currencyListTitle => 'Currencies';

  @override
  String get errorNetwork => 'Network error, please try again later';

  @override
  String get searchHint => 'Search currency name/code';

  @override
  String get unstar => 'Remove from favorites';

  @override
  String get star => 'Add to favorites';

  @override
  String get lastUpdatedLabel => 'Last updated: ';

  @override
  String get offlineDataUpdatedLabel => 'Offline data, updated: ';

  @override
  String get errorFetchFailed =>
      'Failed to load rates. Please check your network and try again.';

  @override
  String get retry => 'Retry';

  @override
  String get settingsCategoryGeneral => 'General';

  @override
  String get settingsCategoryAppearance => 'Appearance';

  @override
  String get settingsCategoryAbout => 'About';
}
