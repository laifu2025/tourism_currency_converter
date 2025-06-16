import 'package:flutter/material.dart';
import 'package:tourism_currency_converter/generated/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String baseCurrency = 'cny';
  List<String> targetCurrencies = ['usd', 'eur', 'jpy', 'gbp'];
  Map<String, double> rates = {};
  double amount = 100;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() { isLoading = true; });
    // TODO: Replace with real API
    rates = {
      'usd': 0.14,
      'eur': 0.13,
      'jpy': 22.0,
      'gbp': 0.11,
    };
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final allCurrencies = {
      'cny': s.currencyListTitle,
      'usd': '美元',
      'eur': '欧元',
      'jpy': '日元',
      'gbp': '英镑',
    };
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
                          onChanged: (v) {
                            setState(() {
                              amount = double.tryParse(v) ?? 0;
                            });
                          },
                        ),
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
                      return ListTile(
                        leading: CircleAvatar(child: Text(code.toUpperCase())),
                        title: Text(allCurrencies[code] ?? code.toUpperCase()),
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
