// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '旅游货币转换';

  @override
  String get converterTitle => '汇率转换器';

  @override
  String get settingsTitle => '设置';

  @override
  String get inputAmount => '输入金额';

  @override
  String get defaultCurrency => '默认货币';

  @override
  String get notSet => '未设置';

  @override
  String get appearance => '外观';

  @override
  String get appearanceSystem => '跟随系统';

  @override
  String get appearanceLight => '浅色模式';

  @override
  String get appearanceDark => '深色模式';

  @override
  String get language => '语言';

  @override
  String get about => '关于';

  @override
  String get aboutView => '查看';

  @override
  String get version => '版本';

  @override
  String get searchCurrency => '搜索货币';

  @override
  String get favorites => '收藏';

  @override
  String get allCurrencies => '所有货币';

  @override
  String get dataSourceInfo => '本应用汇率数据由以下服务提供，数据仅供参考，实际交易汇率以银行柜台为准。';

  @override
  String get dataUpdateInfo => '汇率数据每日更新。';

  @override
  String get tabConverter => '转换器';

  @override
  String get tabCurrencies => '货币列表';

  @override
  String get tabSettings => '设置';

  @override
  String get currencyListTitle => '货币列表';

  @override
  String get errorNetwork => '网络错误，请稍后重试';

  @override
  String get searchHint => '搜索货币名称/代码';

  @override
  String get unstar => '取消收藏';

  @override
  String get star => '收藏';

  @override
  String get lastUpdatedLabel => '更新于: ';

  @override
  String get offlineDataUpdatedLabel => '离线数据, 更新于: ';

  @override
  String get errorFetchFailed => '汇率加载失败，请检查网络后重试。';

  @override
  String get retry => '重试';
}
