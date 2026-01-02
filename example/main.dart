// Copyright (c) 2026 Ouknik
// Licensed under MIT License

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
      title: 'OTP Phone Verify Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedTheme = 'Default';
  String _selectedLanguage = 'English';
  String? _verificationResult;

  // Get your API credentials from https://whatsotp.me
  final OtpConfig _config = OtpConfig(
    apiKey: 'YOUR_API_KEY', // Replace with your API key
    apiSecret: 'YOUR_API_SECRET', // Replace with your API secret
  );

  OtpDialogTheme _getTheme() {
    switch (_selectedTheme) {
      case 'Dark':
        return OtpDialogTheme.dark();
      case 'Blue':
        return OtpDialogTheme.blue();
      case 'Green':
        return OtpDialogTheme.green();
      case 'Purple':
        return OtpDialogTheme.purple();
      default:
        return OtpDialogTheme();
    }
  }

  OtpTranslations _getTranslations() {
    switch (_selectedLanguage) {
      case 'Arabic':
        return OtpTranslations.arabic();
      case 'French':
        return OtpTranslations.french();
      case 'Spanish':
        return OtpTranslations.spanish();
      default:
        return OtpTranslations();
    }
  }

  bool _isRtl() => _selectedLanguage == 'Arabic';

  Future<void> _verifyPhone() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await OtpPhoneVerifyDialog.show(
      context: context,
      config: _config,
      phoneNumber: _phoneController.text.trim(),
      theme: _getTheme(),
      translations: _getTranslations(),
      isRtl: _isRtl(),
    );

    setState(() {
      if (result != null && result.verified) {
        _verificationResult =
            'Phone verified successfully!\nPhone: ${result.phoneNumber}';
      } else if (result != null && result.cancelled) {
        _verificationResult = 'Verification cancelled';
      } else if (result != null) {
        _verificationResult =
            'Verification failed: ${result.error ?? "Unknown error"}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Phone Verify'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'WhatsOTP.me Integration',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Get your API credentials at whatsotp.me'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Phone Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Theme Selector
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(
                labelText: 'Theme',
                prefixIcon: Icon(Icons.palette),
                border: OutlineInputBorder(),
              ),
              items: ['Default', 'Dark', 'Blue', 'Green', 'Purple']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedTheme = v!),
            ),
            const SizedBox(height: 16),

            // Language Selector
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
              items: ['English', 'Arabic', 'French', 'Spanish']
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedLanguage = v!),
            ),
            const SizedBox(height: 24),

            // Verify Button
            ElevatedButton.icon(
              onPressed: _verifyPhone,
              icon: const Icon(Icons.verified),
              label: const Text('Verify Phone Number'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            // Result
            if (_verificationResult != null) ...[
              const SizedBox(height: 24),
              Card(
                color: _verificationResult!.contains('successfully')
                    ? Colors.green[50]
                    : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_verificationResult!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
