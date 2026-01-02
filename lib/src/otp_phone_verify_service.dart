import 'dart:convert';
import 'package:http/http.dart' as http;
import 'otp_config.dart';
import 'otp_result.dart';

/// OTP Phone Verification Service
/// Handles all API communication with the OTP server
class OtpPhoneVerifyService {
  final OtpConfig config;
  final http.Client _client;

  OtpPhoneVerifyService({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Send OTP to phone number
  Future<OtpSendResult> sendOtp(String phoneNumber) async {
    try {
      final uri = Uri.parse('${config.baseUrl}/api/otp/send');

      if (config.debugMode) {
        print('[OTP] Sending OTP to: $phoneNumber');
        print('[OTP] URL: $uri');
      }

      final response = await _client.post(
        uri,
        headers: config.headers,
        body: jsonEncode({
          'phone': phoneNumber,
        }),
      );

      if (config.debugMode) {
        print('[OTP] Response status: ${response.statusCode}');
        print('[OTP] Response body: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return OtpSendResult.fromJson(data);
    } on http.ClientException catch (e) {
      if (config.debugMode) {
        print('[OTP] Network error: $e');
      }
      return OtpSendResult.error('Network error', code: 'NETWORK_ERROR');
    } catch (e) {
      if (config.debugMode) {
        print('[OTP] Error: $e');
      }
      return OtpSendResult.error('An error occurred', code: 'UNKNOWN_ERROR');
    }
  }

  /// Verify OTP code
  Future<OtpVerifyResult> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final uri = Uri.parse('${config.baseUrl}/api/otp/verify');

      if (config.debugMode) {
        print('[OTP] Verifying OTP for: $phoneNumber');
      }

      final response = await _client.post(
        uri,
        headers: config.headers,
        body: jsonEncode({
          'phone': phoneNumber,
          'otp': otpCode,
        }),
      );

      if (config.debugMode) {
        print('[OTP] Verify response: ${response.statusCode}');
        print('[OTP] Response body: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return OtpVerifyResult.fromJson(data);
    } on http.ClientException catch (e) {
      if (config.debugMode) {
        print('[OTP] Network error: $e');
      }
      return OtpVerifyResult.error('Network error', code: 'NETWORK_ERROR');
    } catch (e) {
      if (config.debugMode) {
        print('[OTP] Error: $e');
      }
      return OtpVerifyResult.error('An error occurred', code: 'UNKNOWN_ERROR');
    }
  }

  /// Resend OTP using request ID
  Future<OtpSendResult> resendOtp(String requestId) async {
    try {
      final uri = Uri.parse('${config.baseUrl}/api/otp/resend');

      if (config.debugMode) {
        print('[OTP] Resending OTP for request: $requestId');
      }

      final response = await _client.post(
        uri,
        headers: config.headers,
        body: jsonEncode({
          'request_id': requestId,
        }),
      );

      if (config.debugMode) {
        print('[OTP] Resend response: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return OtpSendResult.fromJson(data);
    } on http.ClientException catch (e) {
      if (config.debugMode) {
        print('[OTP] Network error: $e');
      }
      return OtpSendResult.error('Network error', code: 'NETWORK_ERROR');
    } catch (e) {
      if (config.debugMode) {
        print('[OTP] Error: $e');
      }
      return OtpSendResult.error('An error occurred', code: 'UNKNOWN_ERROR');
    }
  }

  /// Get account balance
  Future<Map<String, dynamic>?> getBalance() async {
    try {
      final uri = Uri.parse('${config.baseUrl}/api/otp/balance');

      final response = await _client.get(
        uri,
        headers: config.headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (config.debugMode) {
        print('[OTP] Balance error: $e');
      }
      return null;
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
