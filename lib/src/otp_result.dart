/// OTP Result classes
/// Contains the result models for OTP operations

/// Result of sending OTP
class OtpSendResult {
  final bool success;
  final String? requestId;
  final String? maskedPhone;
  final int? expiresIn;
  final String? message;
  final String? errorCode;
  final String? error;

  const OtpSendResult({
    required this.success,
    this.requestId,
    this.maskedPhone,
    this.expiresIn,
    this.message,
    this.errorCode,
    this.error,
  });

  factory OtpSendResult.fromJson(Map<String, dynamic> json) {
    return OtpSendResult(
      success: json['success'] ?? false,
      requestId: json['request_id'],
      maskedPhone: json['phone'],
      expiresIn: json['expires_in'],
      message: json['message'],
      errorCode: json['code'],
      error: json['error'],
    );
  }

  factory OtpSendResult.error(String message, {String? code}) {
    return OtpSendResult(
      success: false,
      error: message,
      errorCode: code,
    );
  }
}

/// Result of verifying OTP
class OtpVerifyResult {
  final bool success;
  final bool? verified;
  final String? message;
  final String? errorCode;
  final String? error;

  const OtpVerifyResult({
    required this.success,
    this.verified,
    this.message,
    this.errorCode,
    this.error,
  });

  factory OtpVerifyResult.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResult(
      success: json['success'] ?? false,
      verified: json['verified'],
      message: json['message'],
      errorCode: json['code'],
      error: json['error'],
    );
  }

  factory OtpVerifyResult.error(String message, {String? code}) {
    return OtpVerifyResult(
      success: false,
      verified: false,
      error: message,
      errorCode: code,
    );
  }
}

/// Final verification result returned to the user
class PhoneVerificationResult {
  final bool verified;
  final String phoneNumber;
  final String? requestId;
  final String? error;
  final bool cancelled;

  const PhoneVerificationResult({
    required this.verified,
    required this.phoneNumber,
    this.requestId,
    this.error,
    this.cancelled = false,
  });

  factory PhoneVerificationResult.success(String phone, {String? requestId}) {
    return PhoneVerificationResult(
      verified: true,
      phoneNumber: phone,
      requestId: requestId,
    );
  }

  factory PhoneVerificationResult.failed(String phone, String error) {
    return PhoneVerificationResult(
      verified: false,
      phoneNumber: phone,
      error: error,
    );
  }

  factory PhoneVerificationResult.cancelled(String phone) {
    return PhoneVerificationResult(
      verified: false,
      phoneNumber: phone,
      cancelled: true,
    );
  }
}
