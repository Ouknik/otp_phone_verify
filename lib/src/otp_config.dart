/// OTP Configuration class
/// Contains all the configuration options for the OTP verification service
class OtpConfig {
  /// The base URL of the OTP API
  final String baseUrl;

  /// The API key for authentication
  final String apiKey;

  /// The API secret for authentication
  final String apiSecret;

  /// OTP code length (default: 6)
  final int otpLength;

  /// OTP expiry time in seconds (default: 300 = 5 minutes)
  final int expirySeconds;

  /// Enable/disable resend functionality
  final bool allowResend;

  /// Minimum seconds before allowing resend (default: 60)
  final int resendCooldownSeconds;

  /// Maximum resend attempts (default: 3)
  final int maxResendAttempts;

  /// Custom headers for API requests
  final Map<String, String>? customHeaders;

  /// Enable debug logging
  final bool debugMode;

  const OtpConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.apiSecret,
    this.otpLength = 6,
    this.expirySeconds = 300,
    this.allowResend = true,
    this.resendCooldownSeconds = 60,
    this.maxResendAttempts = 3,
    this.customHeaders,
    this.debugMode = false,
  });

  /// Create config from environment variables or secure storage
  factory OtpConfig.fromMap(Map<String, dynamic> map) {
    return OtpConfig(
      baseUrl: map['baseUrl'] ?? '',
      apiKey: map['apiKey'] ?? '',
      apiSecret: map['apiSecret'] ?? '',
      otpLength: map['otpLength'] ?? 6,
      expirySeconds: map['expirySeconds'] ?? 300,
      allowResend: map['allowResend'] ?? true,
      resendCooldownSeconds: map['resendCooldownSeconds'] ?? 60,
      maxResendAttempts: map['maxResendAttempts'] ?? 3,
      debugMode: map['debugMode'] ?? false,
    );
  }

  /// Get API headers
  Map<String, String> get headers {
    final baseHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': apiKey,
      'X-API-Secret': apiSecret,
    };

    if (customHeaders != null) {
      baseHeaders.addAll(customHeaders!);
    }

    return baseHeaders;
  }
}
