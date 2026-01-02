/// OTP Configuration class
/// Contains API credentials for WhatsOTP service
class OtpConfig {
  /// WhatsOTP API base URL (fixed)
  static const String baseUrl = 'https://whatsotp.me';

  /// Your API Key from WhatsOTP
  final String apiKey;

  /// Your API Secret from WhatsOTP
  final String apiSecret;

  /// OTP length (default 6 digits)
  final int otpLength;

  /// Enable/disable resend functionality
  final bool allowResend;

  /// Minimum seconds before allowing resend (default: 60)
  final int resendCooldownSeconds;

  /// Maximum resend attempts (default: 3)
  final int maxResendAttempts;

  /// Custom headers (optional)
  final Map<String, String>? headers;

  const OtpConfig({
    required this.apiKey,
    required this.apiSecret,
    this.otpLength = 6,
    this.allowResend = true,
    this.resendCooldownSeconds = 60,
    this.maxResendAttempts = 3,
    this.headers,
  });

  /// Get API endpoint for sending OTP
  String get sendOtpEndpoint => '$baseUrl/api/otp/send';

  /// Get API endpoint for verifying OTP
  String get verifyOtpEndpoint => '$baseUrl/api/otp/verify';

  /// Get API endpoint for resending OTP
  String get resendOtpEndpoint => '$baseUrl/api/otp/resend';

  /// Get API endpoint for checking balance
  String get balanceEndpoint => '$baseUrl/api/balance';

  /// Get default headers with authentication
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-KEY': apiKey,
      'X-API-SECRET': apiSecret,
      ...?headers,
    };
  }

  @override
  String toString() {
    return 'OtpConfig(apiKey: *****, apiSecret: *****, otpLength: $otpLength)';
  }
}
