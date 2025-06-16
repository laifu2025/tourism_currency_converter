import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/currency.dart';
import '../../providers/exchange_rate_provider.dart';
import '../widgets/glassmorphic_card.dart';
import 'currencies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExchangeRateProvider>(context, listen: false);
      provider.setAmount(100);
      provider.addListener(_onProviderUpdate);
    });
  }

  @override
  void dispose() {
    Provider.of<ExchangeRateProvider>(context, listen: false)
        .removeListener(_onProviderUpdate);
    _amountController.dispose();
    super.dispose();
  }

  void _onProviderUpdate() {
    final provider = Provider.of<ExchangeRateProvider>(context, listen: false);
    if (provider.amount.toString() != _amountController.text) {
      _amountController.text = provider.amount.toString();
    }
  }

  void _selectCurrency(BuildContext context, bool isFrom) async {
    final provider = Provider.of<ExchangeRateProvider>(context, listen: false);
    final newCurrencyCode = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => CurrenciesPage()),
    );
    if (newCurrencyCode != null) {
      if (isFrom) {
        provider.setFromCurrency(newCurrencyCode);
      } else {
        provider.setToCurrency(newCurrencyCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: _buildMainCard(context, provider),
              ),
            ),
            if (provider.lastUpdated != null)
              SliverToBoxAdapter(
                child: _buildLastUpdated(context, provider.lastUpdated!),
              ),
            if (provider.hasError)
               SliverToBoxAdapter(
                child: _buildErrorDisplay(context, provider),
              ),
             if (!provider.isLoading && !provider.hasError)
              SliverToBoxAdapter(
                child: _buildPopularCurrencies(provider),
              ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(),
            )
          ],
        );
      },
    );
  }

  Widget _buildCurrencyRow(
      BuildContext context, {
        required Currency currency,
        required Widget amountWidget,
        VoidCallback? onTap,
      }) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset('assets/flags/${currency.code.toLowerCase()}.png', width: 50),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency.code,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  currency.name,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: amountWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, ExchangeRateProvider provider) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return GlassmorphicCard(
      child: Column(
        children: [
          _buildCurrencyRow(
            context,
            currency: provider.fromCurrency,
            onTap: () => _selectCurrency(context, true),
            amountWidget: TextField(
              controller: _amountController,
              textAlign: TextAlign.right,
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '100',
                hintStyle: textTheme.displayMedium?.copyWith(
                  color: textColor.withOpacity(0.3),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  provider.setAmount(double.tryParse(value) ?? 0);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              children: [
                Expanded(child: Divider(color: textColor.withOpacity(0.2))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.arrow_right_arrow_left),
                    onPressed: () => provider.swapCurrencies(),
                  ),
                ),
                Expanded(child: Divider(color: textColor.withOpacity(0.2))),
              ],
            ),
          ),
          _buildCurrencyRow(
            context,
            currency: provider.toCurrency,
            onTap: () => _selectCurrency(context, false),
            amountWidget: Text(
              provider.convertedAmountFormatted,
              textAlign: TextAlign.right,
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(
                    provider.convertedAmountFormatted == '...' ? 0.3 : 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context, DateTime lastUpdated) {
     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Center(
        child: Text(
          '${AppLocalizations.of(context)!.lastUpdated}: ${DateFormat.yMd().add_jm().format(lastUpdated)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor.withOpacity(0.6)
          ),
        ).animate().fadeIn(duration: 500.ms),
      ),
    );
  }

  Widget _buildErrorDisplay(BuildContext context, ExchangeRateProvider provider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.dataLoadFailed,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: Text(AppLocalizations.of(context)!.retry),
              onPressed: () => provider.fetchRates(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCurrencies(ExchangeRateProvider provider) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.popularCurrencies,
            style: textTheme.titleMedium?.copyWith(color: textColor.withOpacity(0.7)),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.popularCurrencies.length,
          itemBuilder: (context, index) {
            final rate = provider.popularCurrencies[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                 onTap: () {
                  provider.setFromCurrency(rate.code);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Row(
                    children: [
                      Image.asset('assets/flags/${rate.code.toLowerCase()}.png', width: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${rate.code} - ${rate.name}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                      Text(
                        rate.rate.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        CupertinoIcons.arrow_right_arrow_left,
                        size: 16,
                        color: textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
} 