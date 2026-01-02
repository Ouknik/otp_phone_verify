# OTP Phone Verify

A Flutter library for phone number verification via WhatsApp OTP using the [WhatsOTP.me](https://whatsotp.me) service.

[![pub package](https://img.shields.io/pub/v/otp_phone_verify.svg)](https://pub.dev/packages/otp_phone_verify)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

##  API Documentation

**Full API Documentation:** [WhatsOTP.me API Docs](https://whatsotp.me/user/api-credentials/997c5586-02ae-463a-bf7b-25878dfcf061/docs)

##  Features

-  Send OTP via WhatsApp to any phone number
-  Verify OTP codes with local verification (fast & secure)
-  Resend OTP functionality
-  Check account balance
-  Customizable UI with ready-to-use dialog
-  Supports international phone numbers
-  Easy integration with just a few lines of code

##  Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  otp_phone_verify:
    git:
      url: https://github.com/Ouknik/otp_phone_verify.git
      ref: main
```

Then run:

```bash
flutter pub get
```

##  Getting API Credentials

1. Sign up at [WhatsOTP.me](https://whatsotp.me)
2. Go to your dashboard and get your API credentials
3. View full API documentation: [API Docs](https://whatsotp.me/user/api-credentials/997c5586-02ae-463a-bf7b-25878dfcf061/docs)

##  Quick Start

### Basic Usage with Dialog

The easiest way to implement phone verification:

```dart
import 'package:otp_phone_verify/otp_phone_verify.dart';

// Show verification dialog
final result = await OtpPhoneVerifyDialog.show(
  context: context,
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET',
);

if (result != null && result.success) {
  print('Phone verified successfully!');
  print('Phone: ${result.phone}');
}
```

### Advanced Usage with Service

For more control, use the `OtpPhoneVerifyService` directly:

```dart
import 'package:otp_phone_verify/otp_phone_verify.dart';

final service = OtpPhoneVerifyService(
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET',
);

// Send OTP
final sendResult = await service.sendOtp('+1234567890');
if (sendResult.success) {
  print('OTP sent! Request ID: ${sendResult.requestId}');
  
  // The OTP code is returned for local verification
  print('OTP Code: ${sendResult.otpCode}');
}

// Verify OTP (local verification - fast!)
final verifyResult = await service.verifyOtp(
  '+1234567890',
  '123456',
  requestId: sendResult.requestId,
);

if (verifyResult.success) {
  print('Phone verified!');
}

// Check balance
final balance = await service.getBalance();
print('Balance: ${balance.balance}');
```

### Resend OTP

```dart
final resendResult = await service.resendOtp(
  '+1234567890',
  requestId: previousRequestId,
);
```

##  API Reference

### OtpPhoneVerifyService

| Method | Description |
|--------|-------------|
| `sendOtp(phone)` | Send OTP to phone number |
| `verifyOtp(phone, otp, {requestId})` | Verify OTP code |
| `resendOtp(phone, {requestId})` | Resend OTP |
| `getBalance()` | Get account balance |

### OtpPhoneVerifyDialog

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | BuildContext | Required - Build context |
| `apiKey` | String | Required - Your API key |
| `apiSecret` | String | Required - Your API secret |
| `title` | String | Optional - Dialog title |
| `phoneLabel` | String | Optional - Phone input label |
| `otpLabel` | String | Optional - OTP input label |
| `sendButtonText` | String | Optional - Send button text |
| `verifyButtonText` | String | Optional - Verify button text |

##  Security

- OTP codes are verified locally after being received from the server
- API credentials are sent via secure headers
- All communication uses HTTPS

##  Example App

Check out the [example](example/) directory for a complete working example.

##  Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

##  Links

- [WhatsOTP.me](https://whatsotp.me) - The OTP service provider
- [API Documentation](https://whatsotp.me/user/api-credentials/997c5586-02ae-463a-bf7b-25878dfcf061/docs) - Complete API docs
- [GitHub Repository](https://github.com/Ouknik/otp_phone_verify) - Source code

##  Support

For questions or support, please visit [WhatsOTP.me](https://whatsotp.me) or open an issue on GitHub.
