import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:taptap_exchange/l10n/app_localizations.dart';
import '../../core/constants/currency_country_map.dart';
import '../../data/providers/favorites_provider.dart';
import 'package:collection/collection.dart';

class CurrenciesPage extends StatefulWidget {
  final bool isForSelection;
  const CurrenciesPage({super.key, this.isForSelection = false});

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
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.isForSelection)
                      IconButton(
                        icon: const Icon(CupertinoIcons.arrow_left_circle, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: widget.isForSelection ? 0.0 : 24.0,
                          top: 24.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          s.currencyListTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: CupertinoSearchTextField(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    placeholder: s.searchHint,
                    placeholderStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) => setState(() => search = v),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : error != null
                          ? Center(child: Text(s.errorNetwork, style: const TextStyle(color: Colors.red)))
                          : _buildCurrencyListView(filteredList(starred), favProvider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyListView(List<MapEntry<String, dynamic>> list, FavoritesProvider favProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, idx) {
            final entry = list[idx];
            final code = entry.key.toUpperCase();
            final name = entry.value;
            final isStar = favProvider.favorites.contains(code);
            final countryCode = currencyToCountryCode[code];
            return ListTile(
              onTap: () {
                if (widget.isForSelection) {
                  Navigator.pop(context, code);
                } else {
                  // 在非选择模式下也要有响应，可以添加详情页面或其他交互
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('已选择: $code - $name'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              leading: countryCode != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: SizedBox(
                        width: 40,
                        height: 30,
                        child: SvgPicture.asset(
                          'assets/flags/${countryCode.toLowerCase()}.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white12,
                      child: Text(
                        code.substring(0, code.length > 2 ? 2 : code.length), 
                        style: const TextStyle(color: Colors.white70)
                      ),
                    ),
              title: Text(code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(name, style: const TextStyle(color: Colors.white70)),
              trailing: IconButton(
                icon: Icon(
                  isStar ? CupertinoIcons.star_fill : CupertinoIcons.star,
                  color: isStar ? Colors.amber : Colors.white60,
                ),
                onPressed: () => favProvider.toggleFavorite(code),
              ),
            );
          },
        ),
      ),
    );
  }
}
 