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

  // Configure your WhatsOTP credentials only
  final OtpConfig _config = OtpConfig(
    apiKey: 'your-api-key',       // Get from https://whatsotp.me
    apiSecret: 'your-api-secret', // Get from https://whatsotp.me
  );

  Future<void> _verifyPhone() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    final result = await OtpPhoneVerifyDialog.show(
      context: context,
      config: _config,
      phoneNumber: _phoneController.text.trim(),
    );

    if (result != null && result.verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone verified: ${result.phoneNumber}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Phone Verify'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _verifyPhone,
              icon: const Icon(Icons.verified),
              label: const Text('Verify Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
