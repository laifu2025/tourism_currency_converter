import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/currency_provider.dart';

class CurrenciesPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final listBackgroundColor = isDarkMode
        ? Colors.black.withOpacity(0.4)
        : Colors.grey.shade800.withOpacity(0.4);

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              // ... existing code ...
            ),
          ),
          Consumer<CurrencyProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.currencies.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }

              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: listBackgroundColor,
                    children: provider.currencies.map((currency) {
                      return CupertinoListTile(
                        title: Text(
                          '${currency.code} - ${currency.name}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        onTap: () {
                          provider.setSelectedCurrency(currency.code);
                          Navigator.pop(context, currency.code);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
 