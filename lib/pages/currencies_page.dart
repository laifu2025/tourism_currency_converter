import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_currency_converter/generated/app_localizations.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({Key? key}) : super(key: key);

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  Map<String, dynamic>? currencies;
  bool isLoading = true;
  String? error;
  String search = '';
  Set<String> starred = {};

  // 常见货币代码与国旗代码映射
  static const Map<String, String> currencyFlagMap = {
    'USD': 'us',
    'CNY': 'cn',
    'EUR': 'eu',
    'JPY': 'jp',
    'GBP': 'gb',
    'AUD': 'au',
    'CAD': 'ca',
    'CHF': 'ch',
    'HKD': 'hk',
    'KRW': 'kr',
    'SGD': 'sg',
    'NZD': 'nz',
    'RUB': 'ru',
    'INR': 'in',
    'BRL': 'br',
    'ZAR': 'za',
    'TRY': 'tr',
    'MXN': 'mx',
    'SEK': 'se',
    'NOK': 'no',
    'DKK': 'dk',
    'PLN': 'pl',
    'THB': 'th',
    'IDR': 'id',
    'MYR': 'my',
    'PHP': 'ph',
    'VND': 'vn',
    'TWD': 'tw',
    'SAR': 'sa',
    'AED': 'ae',
    'ILS': 'il',
    'EGP': 'eg',
    'CZK': 'cz',
    'HUF': 'hu',
    'CLP': 'cl',
    'COP': 'co',
    'ARS': 'ar',
    'PKR': 'pk',
    'BDT': 'bd',
    'KZT': 'kz',
    'UAH': 'ua',
    'NGN': 'ng',
    'MAD': 'ma',
    'QAR': 'qa',
    'KWD': 'kw',
    'OMR': 'om',
    'JOD': 'jo',
    'BHD': 'bh',
    'LBP': 'lb',
    'DZD': 'dz',
    'TND': 'tn',
    'IQD': 'iq',
    'SDG': 'sd',
    'LYD': 'ly',
    'YER': 'ye',
    'SYP': 'sy',
    'MOP': 'mo',
    'MNT': 'mn',
    'LAK': 'la',
    'KHR': 'kh',
    'MMK': 'mm',
    'BND': 'bn',
    'BWP': 'bw',
    'GHS': 'gh',
    'KES': 'ke',
    'TZS': 'tz',
    'UGX': 'ug',
    'XOF': 'sn', // 西非法郎用塞内加尔国旗
    'XAF': 'cm', // 中非法郎用喀麦隆国旗
    'XPF': 'pf', // 太平洋法郎用法属波利尼西亚
    'BTC': 'eu', // 比特币无国旗，暂用欧盟
    'ETH': 'eu', // 以太坊无国旗，暂用欧盟
    // ...可继续补充
  };

  @override
  void initState() {
    super.initState();
    loadStarred();
    fetchCurrencies();
  }

  Future<void> loadStarred() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      starred = prefs.getStringList('starred_currencies')?.toSet() ?? {};
    });
  }

  Future<void> toggleStar(String code) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (starred.contains(code)) {
        starred.remove(code);
      } else {
        starred.add(code);
      }
      prefs.setStringList('starred_currencies', starred.toList());
    });
  }

  Future<void> fetchCurrencies() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final res = await http.get(Uri.parse('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json'));
      if (res.statusCode == 200) {
        currencies = json.decode(res.body) as Map<String, dynamic>;
      } else {
        error = '网络错误: 状态码${res.statusCode}';
      }
    } catch (e) {
      error = '加载失败: $e';
    }
    setState(() {
      isLoading = false;
    });
  }

  List<MapEntry<String, dynamic>> get filteredList {
    if (currencies == null) return [];
    final list = currencies!.entries.where((e) {
      final code = e.key.toUpperCase();
      final name = e.value.toString();
      return code.contains(search.toUpperCase()) || name.contains(search);
    }).toList();
    // 收藏的排前面
    list.sort((a, b) {
      final aStar = starred.contains(a.key.toUpperCase()) ? 0 : 1;
      final bStar = starred.contains(b.key.toUpperCase()) ? 0 : 1;
      if (aStar != bStar) return aStar - bStar;
      return a.key.compareTo(b.key);
    });
    return list;
  }

  String? flagUrl(String code) {
    final flag = currencyFlagMap[code.toUpperCase()];
    if (flag == null) return null;
    return 'https://flagcdn.com/w40/$flag.png';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.currencyListTitle),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(s.errorNetwork, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: s.searchHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => search = v),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, idx) {
                          final entry = filteredList[idx];
                          final code = entry.key.toUpperCase();
                          final name = entry.value;
                          final isStar = starred.contains(code);
                          final url = flagUrl(code);
                          return ListTile(
                            leading: url != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(url),
                                    backgroundColor: Colors.grey[200],
                                    onBackgroundImageError: (_, __) {},
                                    child: Text(code),
                                  )
                                : CircleAvatar(child: Text(code)),
                            title: Text('$code  $name'),
                            trailing: IconButton(
                              icon: Icon(
                                isStar ? Icons.star : Icons.star_border,
                                color: isStar ? Colors.amber : Colors.grey,
                              ),
                              onPressed: () => toggleStar(code),
                              tooltip: isStar ? s.unstar : s.star,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
