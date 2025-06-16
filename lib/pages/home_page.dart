import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'package:tourism_currency_converter/data/providers/settings_provider.dart';
import 'package:tourism_currency_converter/data/providers/favorites_provider.dart';
import 'package:tourism_currency_converter/core/services/exchange_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String baseCurrency = 'cny';
  Map<String, double> rates = {};
  double amount = 100;
  bool isLoading = true;
  bool _isDefaultCurrencySet = false;
  Map<String, String> currencyNames = {};

  @override
  void initState() {
    super.initState();
    fetchCurrencyNamesAndRates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDefaultCurrencySet) {
      final defaultCurrency = context.watch<SettingsProvider>().defaultCurrency;
      if (defaultCurrency != null) {
        setState(() {
          baseCurrency = defaultCurrency.toLowerCase();
        });
        fetchCurrencyNamesAndRates();
      }
      _isDefaultCurrencySet = true;
    }
  }

  Future<void> fetchCurrencyNamesAndRates() async {
    setState(() { isLoading = true; });
    try {
      // 拉取币种名称映射
      final url = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        currencyNames = data.map((k, v) => MapEntry(k.toLowerCase(), v.toString()));
      }
      // 拉取汇率
      rates = await ExchangeService.fetchRates(baseCurrency);
    } catch (e) {
      rates = {};
    }
    setState(() { isLoading = false; });
  }

  void onAmountChanged(String v) {
    setState(() {
      amount = double.tryParse(v) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final favorites = context.watch<FavoritesProvider>().favorites.toList();
    final targetCurrencies = favorites.isNotEmpty ? favorites.map((e) => e.toLowerCase()).toList() : ['usd', 'eur', 'jpy', 'gbp'];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.converterTitle),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(child: Text(baseCurrency.toUpperCase())),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: s.inputAmount,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: onAmountChanged,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: '刷新汇率',
                        onPressed: fetchCurrencyNamesAndRates,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: targetCurrencies.length,
                    itemBuilder: (context, idx) {
                      final code = targetCurrencies[idx];
                      final value = rates[code] != null ? (amount * rates[code]!).toStringAsFixed(2) : '--';
                      final name = currencyNames[code] ?? code.toUpperCase();
                      return ListTile(
                        leading: CircleAvatar(child: Text(code.toUpperCase())),
                        title: Text(name),
                        trailing: Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
