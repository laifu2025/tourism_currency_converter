import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taptap_exchange/core/services/location_service.dart';
import 'package:taptap_exchange/l10n/app_localizations.dart';
import 'package:taptap_exchange/core/constants/currency_country_map.dart' as currency_map;
import 'package:taptap_exchange/data/providers/settings_provider.dart';
import 'package:taptap_exchange/data/providers/favorites_provider.dart';
import 'package:taptap_exchange/core/services/exchange_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taptap_exchange/presentation/widgets/breathing_background.dart';
import 'package:taptap_exchange/presentation/widgets/glassmorphic_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String baseCurrency = 'cny';
  String targetCurrency = 'usd';
  Map<String, double> rates = {};
  double amount = 100;
  bool isLoading = true;
  String? errorMessage;
  DateTime? lastUpdated;
  bool isOffline = false;
  Map<String, String> currencyNames = {};
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchData();
    await _maybeSetCurrencyByLocation();
  }

  Future<void> _maybeSetCurrencyByLocation() async {
    final settingsProvider = context.read<SettingsProvider>();
    // Only fetch location if no default currency is set
    if (settingsProvider.defaultCurrency == null) {
      final currencyCode = await _locationService.getCurrencyCodeFromLocation();
      if (currencyCode != null && currencyCode.isNotEmpty && mounted) {
        _handleCurrencyChange(currencyCode);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final defaultCurrency = context.watch<SettingsProvider>().defaultCurrency;
    if (defaultCurrency != null && baseCurrency != defaultCurrency) {
      _handleCurrencyChange(defaultCurrency);
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
          errorMessage = 'FETCH_FAILED';
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

  Future<void> _swapCurrencies() async {
    setState(() {
      final temp = baseCurrency;
      baseCurrency = targetCurrency;
      targetCurrency = temp;
    });
    // After swapping, we need to fetch new rates for the new base currency
    await fetchRates(); 
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final favorites = context.watch<FavoritesProvider>().favorites.toList();
    final targetCurrencies = favorites.isNotEmpty ? favorites.map((e) => e.toLowerCase()).toList() : ['usd', 'eur', 'jpy', 'gbp'];
    
    return BreathingBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildInputPanel(s),
              _buildInfoPanel(),
              const Divider(height: 1, color: Colors.white24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                          ? _buildErrorPanel(errorMessage!)
                          : _buildRatesList(targetCurrencies, s),
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isOffline)
            Icon(Icons.cloud_off, size: 14, color: Theme.of(context).colorScheme.secondary),
          if (isOffline)
            const SizedBox(width: 8),
          Text(
            '$label$formattedDate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOffline ? Colors.orangeAccent : Colors.white60,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPanel(AppLocalizations s) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GlassmorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrencyRow(s, isBaseCurrency: true, onTap: () async {
                final result = await Navigator.pushNamed(context, '/currencies', arguments: true);
                if (result != null && result is String && mounted) {
                  context.read<SettingsProvider>().setDefaultCurrency(result); // Set as default currency
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white30)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.arrow_right_arrow_left, color: Colors.white70),
                        onPressed: _swapCurrencies,
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white30)),
                  ],
                ),
              ),
              _buildCurrencyRow(s, isBaseCurrency: false, onTap: () async {
                final newCurrency = await Navigator.pushNamed(context, '/currencies', arguments: true);
                if (newCurrency != null && newCurrency is String) {
                  setState(() {
                    targetCurrency = newCurrency.toLowerCase();
                  });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(AppLocalizations s, {required bool isBaseCurrency, required Function() onTap}) {
    final currencyCode = isBaseCurrency ? baseCurrency : targetCurrency;
    final countryC = currency_map.currencyToCountryCode[currencyCode.toUpperCase()];
    final currencyName = currencyNames[currencyCode] ?? currencyCode.toUpperCase();
    final amountToShow = isBaseCurrency
        ? amount
        : (rates[targetCurrency] != null ? (amount * rates[targetCurrency]!) : 0);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: countryC != null
                ? SizedBox(
                    width: 50,
                    height: 36,
                    child: SvgPicture.asset(
                      'assets/flags/${countryC.toLowerCase()}.svg',
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white12,
                    child: Text(
                      currencyCode.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currencyCode.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(currencyName, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          isBaseCurrency
              ? Expanded(
                  child: IntrinsicWidth(
                    child: TextField(
                      controller: _amountController,
                      textAlign: TextAlign.end,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: Colors.white30)),
                      onChanged: onAmountChanged,
                    ),
                  ),
                )
              : Text(
                  amountToShow.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
        ],
      ),
    );
  }

  Widget _buildErrorPanel(String error) {
    final s = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              s.errorFetchFailed,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchRates,
              child: Text(s.retry),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatesList(List<String> targetCurrencies, AppLocalizations s) {
    if (targetCurrencies.isEmpty) {
      return Center(
        child: Text(
          "Add currencies to your favorites to see them here.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: targetCurrencies.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, idx) {
            final code = targetCurrencies[idx];
            final value = rates[code] != null ? (amount * rates[code]!).toStringAsFixed(2) : '--';
            final name = currencyNames[code] ?? code.toUpperCase();
            final countryCode = currency_map.currencyToCountryCode[code.toUpperCase()];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: countryCode != null
                    ? SizedBox(
                        width: 40,
                        height: 30,
                        child: SvgPicture.asset(
                          'assets/flags/${countryCode.toLowerCase()}.svg',
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white12,
                        child: Text(code.toUpperCase().substring(0, code.length > 2 ? 2 : code.length), style: const TextStyle(color: Colors.white70)),
                      ),
              ),
              title: Text(name, style: const TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(CupertinoIcons.arrow_right_arrow_left, size: 20, color: Colors.white60),
                    tooltip: 'Set as base currency',
                    onPressed: () => _handleCurrencyChange(code),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
