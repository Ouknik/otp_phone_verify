import 'package:flutter_test/flutter_test.dart';
import 'package:otp_phone_verify/otp_phone_verify.dart';

void main() {
  group('OtpConfig', () {
    test('creates config with required parameters', () {
      final config = OtpConfig(
        apiKey: 'test-api-key',
        apiSecret: 'test-api-secret',
      );

      expect(config.apiKey, 'test-api-key');
      expect(config.apiSecret, 'test-api-secret');
      expect(config.otpLength, 6);
      expect(OtpConfig.baseUrl, 'https://whatsotp.me');
    });

    test('creates config with custom parameters', () {
      final config = OtpConfig(
        apiKey: 'test-key',
        apiSecret: 'test-secret',
        otpLength: 4,
        allowResend: false,
        maxResendAttempts: 5,
      );

      expect(config.otpLength, 4);
      expect(config.allowResend, false);
      expect(config.maxResendAttempts, 5);
    });

    test('generates correct endpoints', () {
      final config = OtpConfig(
        apiKey: 'key',
        apiSecret: 'secret',
      );

      expect(config.sendOtpEndpoint, 'https://whatsotp.me/api/otp/send');
      expect(config.verifyOtpEndpoint, 'https://whatsotp.me/api/otp/verify');
      expect(config.resendOtpEndpoint, 'https://whatsotp.me/api/otp/resend');
      expect(config.balanceEndpoint, 'https://whatsotp.me/api/balance');
    });

    test('generates correct headers', () {
      final config = OtpConfig(
        apiKey: 'my-api-key',
        apiSecret: 'my-api-secret',
      );

      final headers = config.getHeaders();
      expect(headers['X-API-KEY'], 'my-api-key');
      expect(headers['X-API-SECRET'], 'my-api-secret');
      expect(headers['Content-Type'], 'application/json');
    });
  });

  group('OtpDialogTheme', () {
    test('creates default theme', () {
      final theme = OtpDialogTheme();
      expect(theme.primaryColor, isNotNull);
      expect(theme.borderRadius, 20.0);
    });

    test('creates dark theme', () {
      final theme = OtpDialogTheme.dark();
      expect(theme.backgroundColor.red, lessThan(50));
    });
  });

  group('OtpTranslations', () {
    test('creates default translations', () {
      final translations = OtpTranslations();
      expect(translations.title, 'Verify Phone');
    });

    test('creates arabic translations', () {
      final translations = OtpTranslations.arabic();
      expect(translations.title, contains('تأكيد'));
    });

    test('creates french translations', () {
      final translations = OtpTranslations.french();
      expect(translations.title, contains('rifier'));
    });
  });

  group('OtpSendResult', () {
    test('creates from json', () {
      final result = OtpSendResult.fromJson({
        'success': true,
        'request_id': '123',
        'message': 'OTP sent',
      });

      expect(result.success, true);
      expect(result.requestId, '123');
    });

    test('creates error result', () {
      final result = OtpSendResult.error('Network error', code: 'E001');
      expect(result.success, false);
      expect(result.error, 'Network error');
    });
  });

  group('PhoneVerificationResult', () {
    test('creates success result', () {
      final result = PhoneVerificationResult.success('+1234567890');
      expect(result.verified, true);
      expect(result.phoneNumber, '+1234567890');
    });

    test('creates cancelled result', () {
      final result = PhoneVerificationResult.cancelled('+1234567890');
      expect(result.verified, false);
      expect(result.cancelled, true);
    });
  });
}
