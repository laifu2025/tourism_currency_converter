class AppConfig {
  final bool isRedirectEnabled;
  final String? redirectUrl;

  AppConfig({
    required this.isRedirectEnabled,
    this.redirectUrl,
  });

  // For simulating server response
  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      isRedirectEnabled: json['isRedirectEnabled'] as bool,
      redirectUrl: json['redirectUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRedirectEnabled': isRedirectEnabled,
      'redirectUrl': redirectUrl,
    };
  }
} 