# OTP Phone Verify

A beautiful and customizable Flutter package for phone number verification using WhatsApp OTP via [WhatsOTP.me](https://whatsotp.me) service.

[![pub package](https://img.shields.io/pub/v/otp_phone_verify.svg)](https://pub.dev/packages/otp_phone_verify)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

##  Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/Ouknik/otp_phone_verify/main/screenshots/phone_input.jpeg" width="300" alt="Phone Input Screen">
  <img src="https://raw.githubusercontent.com/Ouknik/otp_phone_verify/main/screenshots/otp_input.jpeg" width="300" alt="OTP Input Screen">
</p>

##  API Documentation

**Full API Documentation:** [WhatsOTP.me API Docs](https://whatsotp.me/user/api-credentials/997c5586-02ae-463a-bf7b-25878dfcf061/docs)

##  Features

-  Send OTP via WhatsApp to any phone number
-  Verify OTP codes with local verification (fast & secure)
-  Resend OTP functionality with countdown timer
-  Check account balance
-  Multiple theme presets (Default, Dark, Blue, Green, Purple)
-  Multi-language support (English, Arabic, French, Spanish)
-  RTL support for Arabic
-  Easy integration with just a few lines of code

##  Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  otp_phone_verify: ^1.0.3
```

Or from GitHub:

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

// Configure your credentials
final config = OtpConfig(
  apiKey: 'YOUR_API_KEY',
  apiSecret: 'YOUR_API_SECRET',
);

// Show verification dialog
final result = await OtpPhoneVerifyDialog.show(
  context: context,
  config: config,
  phoneNumber: '+1234567890',
);

if (result != null && result.verified) {
  print('Phone verified successfully!');
  print('Phone: ${result.phoneNumber}');
}
```

### With Custom Theme

```dart
final result = await OtpPhoneVerifyDialog.show(
  context: context,
  config: config,
  phoneNumber: '+1234567890',
  theme: OtpDialogTheme.dark(), // or .blue(), .green(), .purple()
);
```

### With Arabic Language (RTL)

```dart
final result = await OtpPhoneVerifyDialog.show(
  context: context,
  config: config,
  phoneNumber: '+1234567890',
  translations: OtpTranslations.arabic(),
  isRtl: true,
);
```

##  Available Themes

| Theme | Description |
|-------|-------------|
| `OtpDialogTheme()` | Default light theme |
| `OtpDialogTheme.dark()` | Dark mode theme |
| `OtpDialogTheme.blue()` | Blue accent theme |
| `OtpDialogTheme.green()` | Green accent theme |
| `OtpDialogTheme.purple()` | Purple accent theme |

##  Available Languages

| Language | Usage |
|----------|-------|
| English | `OtpTranslations()` |
| Arabic | `OtpTranslations.arabic()` |
| French | `OtpTranslations.french()` |
| Spanish | `OtpTranslations.spanish()` |

##  API Reference

### OtpConfig

| Parameter | Type | Description |
|-----------|------|-------------|
| `apiKey` | String | Your WhatsOTP.me API key |
| `apiSecret` | String | Your WhatsOTP.me API secret |

### OtpPhoneVerifyDialog.show()

| Parameter | Type | Description |
|-----------|------|-------------|
| `context` | BuildContext | Required - Build context |
| `config` | OtpConfig | Required - API configuration |
| `phoneNumber` | String | Required - Phone number to verify |
| `theme` | OtpDialogTheme | Optional - Dialog theme |
| `translations` | OtpTranslations | Optional - Text translations |
| `isRtl` | bool | Optional - RTL layout support |

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
- [pub.dev](https://pub.dev/packages/otp_phone_verify) - Package page

##  Support

For questions or support, please visit [WhatsOTP.me](https://whatsotp.me) or open an issue on GitHub.
