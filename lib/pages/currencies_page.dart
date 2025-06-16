import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import '../core/constants/currency_country_map.dart';
import '../data/providers/favorites_provider.dart';

class CurrenciesPage extends StatefulWidget {
  final bool isForSelection;
  const CurrenciesPage({Key? key, this.isForSelection = false}) : super(key: key);

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  Map<String, dynamic>? currencies;
  bool isLoading = true;
  String? error;
  String search = '';

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
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

  List<MapEntry<String, dynamic>> filteredList(Set<String> starred) {
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

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, _) {
        final starred = favProvider.favorites.map((e) => e.toUpperCase()).toSet();
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
                            itemCount: filteredList(starred).length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, idx) {
                              final entry = filteredList(starred)[idx];
                              final code = entry.key.toUpperCase();
                              final name = entry.value;
                              final isStar = starred.contains(code);
                              final countryCode = currencyToCountryCode[code];
                              return ListTile(
                                onTap: () {
                                  if (widget.isForSelection) {
                                    Navigator.pop(context, code);
                                  }
                                },
                                leading: countryCode != null
                                    ? SizedBox(
                                        width: 40,
                                        height: 30,
                                        child: SvgPicture.asset(
                                          'assets/flags/${countryCode.toLowerCase()}.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        child: Text(code.substring(0, code.length > 2 ? 2 : code.length)),
                                      ),
                                title: Text('$code  $name'),
                                trailing: IconButton(
                                  icon: Icon(
                                    isStar ? Icons.star : Icons.star_border,
                                    color: isStar ? Colors.amber : Colors.grey,
                                  ),
                                  onPressed: () => favProvider.toggleFavorite(code),
                                  tooltip: isStar ? s.unstar : s.star,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
