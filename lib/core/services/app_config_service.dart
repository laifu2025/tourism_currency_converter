import 'package:tourism_currency_converter/data/models/app_config.dart';

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