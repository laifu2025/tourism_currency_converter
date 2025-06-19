import 'package:taptap_exchange/data/models/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kDebugMode;

class AppConfigService {
  Future<AppConfig> fetchAppConfig() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate server response
    // Set isRedirectEnabled to true to test redirection
    // Set redirectUrl to a valid URL for testing
    return AppConfig(
      isRedirectEnabled: false,
      redirectUrl: 'https://flutter.dev/',
    );
  }
} 