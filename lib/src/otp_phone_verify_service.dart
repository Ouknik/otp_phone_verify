import 'dart:convert';
import 'package:http/http.dart' as http;
import 'otp_config.dart';
import 'otp_result.dart';

/// OTP Phone Verification Service
/// Handles all API communication with WhatsOTP
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
      final response = await _client.post(
        Uri.parse(config.sendOtpEndpoint),
        headers: config.getHeaders(),
        body: jsonEncode({
          'phone': phoneNumber,
          'otp_length': config.otpLength,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpSendResult.fromJson(data);
      } else {
        return OtpSendResult.error(
          data['message'] ?? data['error'] ?? 'Failed to send OTP',
          code: data['code']?.toString(),
        );
      }
    } catch (e) {
      return OtpSendResult.error('Network error: $e');
    }
  }

  /// Verify OTP code
  Future<OtpVerifyResult> verifyOtp(String phoneNumber, String otpCode, {String? requestId}) async {
    try {
      final body = <String, dynamic>{
        'phone': phoneNumber,
        'otp': otpCode,
      };
      
      if (requestId != null) {
        body['request_id'] = requestId;
      }

      final response = await _client.post(
        Uri.parse(config.verifyOtpEndpoint),
        headers: config.getHeaders(),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200) {
        return OtpVerifyResult.fromJson(data);
      } else {
        return OtpVerifyResult.error(
          data['message'] ?? data['error'] ?? 'Failed to verify OTP',
          code: data['code']?.toString(),
        );
      }
    } catch (e) {
      return OtpVerifyResult.error('Network error: $e');
    }
  }

  /// Resend OTP to phone number
  Future<OtpSendResult> resendOtp(String phoneNumber, {String? requestId}) async {
    try {
      final body = <String, dynamic>{
        'phone': phoneNumber,
        'otp_length': config.otpLength,
      };
      
      if (requestId != null) {
        body['request_id'] = requestId;
      }

      final response = await _client.post(
        Uri.parse(config.resendOtpEndpoint),
        headers: config.getHeaders(),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpSendResult.fromJson(data);
      } else {
        return OtpSendResult.error(
          data['message'] ?? data['error'] ?? 'Failed to resend OTP',
          code: data['code']?.toString(),
        );
      }
    } catch (e) {
      return OtpSendResult.error('Network error: $e');
    }
  }

  /// Get account balance
  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await _client.get(
        Uri.parse(config.balanceEndpoint),
        headers: config.getHeaders(),
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'error': 'Network error: $e'};
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
