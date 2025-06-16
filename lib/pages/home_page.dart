import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/l10n/app_localizations.dart';
import 'package:tourism_currency_converter/core/constants/currency_country_map.dart' as currency_map;
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
  String? errorMessage;
  DateTime? lastUpdated;
  bool isOffline = false;
  bool _isDefaultCurrencySet = false;
  Map<String, String> currencyNames = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDefaultCurrencySet) {
      final defaultCurrency = context.watch<SettingsProvider>().defaultCurrency;
      if (defaultCurrency != null) {
        _handleCurrencyChange(defaultCurrency);
      }
      _isDefaultCurrencySet = true;
    }
  }

  Future<void> _fetchData() async {
    await fetchCurrencyNames();
    await fetchRates();
  }

  Future<void> fetchCurrencyNames() async {
    if (currencyNames.isNotEmpty) return;
    try {
      final url = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            currencyNames = data.map((k, v) => MapEntry(k.toLowerCase(), v.toString()));
          });
        }
      }
    } catch (e) {
      // Could load from a bundled asset as fallback
    }
  }

  Future<void> fetchRates() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await ExchangeService.fetchRates(baseCurrency);
      if (mounted) {
        setState(() {
          rates = data.rates;
          lastUpdated = data.lastUpdated;
          isOffline = data.isOffline;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString().replaceFirst("Exception: ", "");
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onAmountChanged(String v) {
    setState(() {
      amount = double.tryParse(v) ?? 0;
    });
  }

  void _handleCurrencyChange(String newCurrency) {
    setState(() {
      baseCurrency = newCurrency.toLowerCase();
    });
    fetchRates();
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
      body: Column(
        children: [
          _buildInputPanel(s),
          _buildInfoPanel(),
          const Divider(height: 1),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? _buildErrorPanel(errorMessage!)
                    : _buildRatesList(targetCurrencies, s),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    if (isLoading) return const SizedBox.shrink();

    final s = AppLocalizations.of(context)!;
    String formattedDate = lastUpdated != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(lastUpdated!)
        : 'N/A';
    
    final label = isOffline ? s.offlineDataUpdatedLabel : s.lastUpdatedLabel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isOffline)
            const Icon(Icons.cloud_off, size: 16, color: Colors.orange),
          if (isOffline)
            const SizedBox(width: 8),
          Text(
            '$label$formattedDate',
            style: TextStyle(
              color: isOffline ? Colors.orange : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPanel(AppLocalizations s) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              final newCurrency = await Navigator.pushNamed(context, '/currencies', arguments: true);
              if (newCurrency != null && newCurrency is String) {
                _handleCurrencyChange(newCurrency);
              }
            },
            child: currency_map.currencyToCountryCode[baseCurrency.toUpperCase()] != null
                ? SizedBox(
                    width: 40,
                    height: 30,
                    child: SvgPicture.asset(
                      'assets/flags/${currency_map.currencyToCountryCode[baseCurrency.toUpperCase()]!.toLowerCase()}.svg',
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    child: Text(baseCurrency.toUpperCase()),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onPressed: fetchRates,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPanel(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchRates,
              child: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatesList(List<String> targetCurrencies, AppLocalizations s) {
    return ListView.builder(
      itemCount: targetCurrencies.length,
      itemBuilder: (context, idx) {
        final code = targetCurrencies[idx];
        final value = rates[code] != null ? (amount * rates[code]!).toStringAsFixed(2) : '--';
        final name = currencyNames[code] ?? code.toUpperCase();
        final countryCode = currency_map.currencyToCountryCode[code.toUpperCase()];
        return ListTile(
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
                  child: Text(code.toUpperCase().substring(0, code.length > 2 ? 2 : code.length)),
                ),
          title: Text(name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.swap_horiz),
                tooltip: 'Set as base currency',
                onPressed: () => _handleCurrencyChange(code),
              ),
            ],
          ),
        );
      },
    );
  }
}
