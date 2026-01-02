import 'package:flutter/material.dart';
import 'package:otp_phone_verify/otp_phone_verify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Phone Verify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _verifiedPhone;
  String _selectedTheme = 'default';
  String _selectedLanguage = 'english';

  // Configure your API here
  final _config = const OtpConfig(
    baseUrl: 'https://your-api.com',  // Replace with your API URL
    apiKey: 'your-api-key',            // Replace with your API key
    apiSecret: 'your-api-secret',      // Replace with your API secret
    otpLength: 6,
    debugMode: true,
  );

  OtpDialogTheme get _theme {
    switch (_selectedTheme) {
      case 'dark':
        return OtpDialogTheme.dark();
      case 'blue':
        return OtpDialogTheme.blue();
      case 'green':
        return OtpDialogTheme.green();
      case 'purple':
        return OtpDialogTheme.purple();
      default:
        return const OtpDialogTheme();
    }
  }

  OtpTranslations get _translations {
    switch (_selectedLanguage) {
      case 'arabic':
        return OtpTranslations.arabic(appName: 'تطبيقي');
      case 'french':
        return OtpTranslations.french(appName: 'Mon App');
      case 'spanish':
        return OtpTranslations.spanish(appName: 'Mi App');
      default:
        return const OtpTranslations(appName: 'My App');
    }
  }

  bool get _isRtl => _selectedLanguage == 'arabic';

  Future<void> _verifyPhone() async {
    final result = await OtpPhoneVerifyDialog.show(
      context: context,
      config: _config,
      theme: _theme,
      translations: _translations,
      isRtl: _isRtl,
    );

    if (result == null) {
      _showSnackBar('Dialog dismissed');
      return;
    }

    if (result.cancelled) {
      _showSnackBar('Verification cancelled');
      return;
    }

    if (result.verified) {
      setState(() => _verifiedPhone = result.phoneNumber);
      _showSnackBar('Phone verified successfully!', isSuccess: true);
    } else {
      _showSnackBar('Verification failed: ${result.error}');
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Phone Verify Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Theme selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Theme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildThemeChip('default', 'Default'),
                        _buildThemeChip('dark', 'Dark'),
                        _buildThemeChip('blue', 'Blue'),
                        _buildThemeChip('green', 'Green'),
                        _buildThemeChip('purple', 'Purple'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Language selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildLanguageChip('english', 'English'),
                        _buildLanguageChip('arabic', 'العربية'),
                        _buildLanguageChip('french', 'Français'),
                        _buildLanguageChip('spanish', 'Español'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Verify button
            ElevatedButton.icon(
              onPressed: _verifyPhone,
              icon: const Icon(Icons.phone_android),
              label: const Text('Verify Phone Number'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),

            // Result
            if (_verifiedPhone != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verified Phone',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _verifiedPhone!,
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedTheme == value,
      onSelected: (selected) {
        if (selected) setState(() => _selectedTheme = value);
      },
    );
  }

  Widget _buildLanguageChip(String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedLanguage == value,
      onSelected: (selected) {
        if (selected) setState(() => _selectedLanguage = value);
      },
    );
  }
}
