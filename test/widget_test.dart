// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';
import 'package:tourism_currency_converter/main.dart';
import 'package:tourism_currency_converter/data/providers/theme_provider.dart';
import 'package:tourism_currency_converter/data/providers/settings_provider.dart';
import 'package:tourism_currency_converter/data/providers/favorites_provider.dart';

void main() {
  testWidgets('App starts and displays main tabs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: const LocaleApp(),
      ),
    );

    // Wait for app to load
    await tester.pumpAndSettle();

    // Verify that bottom navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
