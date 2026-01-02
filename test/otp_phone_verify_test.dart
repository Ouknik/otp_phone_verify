import 'package:flutter_test/flutter_test.dart';
import 'package:otp_phone_verify/otp_phone_verify.dart';

void main() {
  group('OtpConfig', () {
    test('should create config with required parameters', () {
      const config = OtpConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        apiSecret: 'test-secret',
      );

      expect(config.baseUrl, 'https://api.example.com');
      expect(config.apiKey, 'test-key');
      expect(config.apiSecret, 'test-secret');
      expect(config.otpLength, 6);
      expect(config.resendCooldownSeconds, 60);
    });

    test('should generate correct headers', () {
      const config = OtpConfig(
        baseUrl: 'https://api.example.com',
        apiKey: 'my-key',
        apiSecret: 'my-secret',
      );

      final headers = config.headers;
      expect(headers['X-API-Key'], 'my-key');
      expect(headers['X-API-Secret'], 'my-secret');
      expect(headers['Content-Type'], 'application/json');
    });
  });

  group('OtpTranslations', () {
    test('should have English as default', () {
      const translations = OtpTranslations();
      expect(translations.title, 'Phone Verification');
      expect(translations.sendButton, 'Send Code');
    });

    test('should create Arabic translations', () {
      final translations = OtpTranslations.arabic(appName: 'تطبيقي');
      expect(translations.title, 'تأكيد رقم الهاتف');
      expect(translations.appName, 'تطبيقي');
    });

    test('should format resend countdown', () {
      const translations = OtpTranslations();
      expect(translations.formatResendCountdown(30), 'Resend in 30s');
    });
  });

  group('OtpDialogTheme', () {
    test('should have default values', () {
      const theme = OtpDialogTheme();
      expect(theme.borderRadius, 24.0);
      expect(theme.enableHapticFeedback, true);
    });

    test('should create dark theme', () {
      final theme = OtpDialogTheme.dark();
      expect(theme.backgroundColor.value, 0xFF1F2937);
    });
  });

  group('OtpSendResult', () {
    test('should parse success response', () {
      final result = OtpSendResult.fromJson({
        'success': true,
        'request_id': 'uuid-123',
        'phone': '+212******00',
        'expires_in': 300,
      });

      expect(result.success, true);
      expect(result.requestId, 'uuid-123');
      expect(result.expiresIn, 300);
    });

    test('should create error result', () {
      final result = OtpSendResult.error('Network error', code: 'NETWORK_ERROR');
      expect(result.success, false);
      expect(result.error, 'Network error');
      expect(result.errorCode, 'NETWORK_ERROR');
    });
  });

  group('PhoneVerificationResult', () {
    test('should create success result', () {
      final result = PhoneVerificationResult.success('+212600000000');
      expect(result.verified, true);
      expect(result.phoneNumber, '+212600000000');
      expect(result.cancelled, false);
    });

    test('should create cancelled result', () {
      final result = PhoneVerificationResult.cancelled('+212600000000');
      expect(result.verified, false);
      expect(result.cancelled, true);
    });
  });
}
