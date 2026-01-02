import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'otp_config.dart';
import 'otp_theme.dart';
import 'otp_translations.dart';
import 'otp_result.dart';
import 'otp_phone_verify_service.dart';

/// OTP Phone Verification Dialog
/// A beautiful popup dialog for phone number verification
class OtpPhoneVerifyDialog extends StatefulWidget {
  /// The phone number to verify (optional - can be entered by user)
  final String? phoneNumber;

  /// OTP Configuration
  final OtpConfig config;

  /// Custom theme
  final OtpDialogTheme theme;

  /// Translations
  final OtpTranslations translations;

  /// Show phone input field (if false, phoneNumber is required)
  final bool showPhoneInput;

  /// Auto-focus OTP input
  final bool autoFocusOtp;

  /// Custom phone validator
  final String? Function(String?)? phoneValidator;

  /// Called when OTP is sent
  final void Function(OtpSendResult)? onOtpSent;

  /// Called when verification is complete
  final void Function(PhoneVerificationResult)? onVerificationComplete;

  /// Custom header widget
  final Widget? headerWidget;

  /// Custom footer widget
  final Widget? footerWidget;

  /// RTL support
  final bool isRtl;

  const OtpPhoneVerifyDialog({
    super.key,
    this.phoneNumber,
    required this.config,
    this.theme = const OtpDialogTheme(),
    this.translations = const OtpTranslations(),
    this.showPhoneInput = true,
    this.autoFocusOtp = true,
    this.phoneValidator,
    this.onOtpSent,
    this.onVerificationComplete,
    this.headerWidget,
    this.footerWidget,
    this.isRtl = false,
  });

  /// Show the verification dialog
  static Future<PhoneVerificationResult?> show({
    required BuildContext context,
    required OtpConfig config,
    String? phoneNumber,
    OtpDialogTheme theme = const OtpDialogTheme(),
    OtpTranslations translations = const OtpTranslations(),
    bool showPhoneInput = true,
    bool barrierDismissible = false,
    bool isRtl = false,
    Widget? headerWidget,
    Widget? footerWidget,
  }) {
    return showDialog<PhoneVerificationResult>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (context) => OtpPhoneVerifyDialog(
        phoneNumber: phoneNumber,
        config: config,
        theme: theme,
        translations: translations,
        showPhoneInput: showPhoneInput,
        isRtl: isRtl,
        headerWidget: headerWidget,
        footerWidget: footerWidget,
      ),
    );
  }

  @override
  State<OtpPhoneVerifyDialog> createState() => _OtpPhoneVerifyDialogState();
}

class _OtpPhoneVerifyDialogState extends State<OtpPhoneVerifyDialog>
    with SingleTickerProviderStateMixin {
  late OtpPhoneVerifyService _service;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _otpFocusNode = FocusNode();

  bool _isLoading = false;
  bool _otpSent = false;
  String? _error;
  String? _requestId;
  int _resendCountdown = 0;
  int _resendAttempts = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _service = OtpPhoneVerifyService(config: widget.config);
    _phoneController.text = widget.phoneNumber ?? '';

    _animationController = AnimationController(
      duration: widget.theme.animationDuration,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _animationController.forward();

    // Auto-send OTP if phone is provided and input is hidden
    if (!widget.showPhoneInput && widget.phoneNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendOtp();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _phoneFocusNode.dispose();
    _otpFocusNode.dispose();
    _countdownTimer?.cancel();
    _service.dispose();
    super.dispose();
  }

  String get _phone => _phoneController.text.trim();

  Future<void> _sendOtp() async {
    if (_phone.isEmpty) {
      setState(() => _error = widget.translations.invalidPhoneMessage);
      return;
    }

    // Validate phone
    if (widget.phoneValidator != null) {
      final validationError = widget.phoneValidator!(_phone);
      if (validationError != null) {
        setState(() => _error = validationError);
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (widget.theme.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    final result = await _service.sendOtp(_phone);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result.success) {
        _otpSent = true;
        _requestId = result.requestId;
        _startResendCountdown();
        if (widget.autoFocusOtp) {
          _otpFocusNode.requestFocus();
        }
      } else {
        _error = _mapErrorMessage(result.errorCode, result.error);
      }
    });

    widget.onOtpSent?.call(result);
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != widget.config.otpLength) {
      setState(() => _error = widget.translations.invalidOtpMessage);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (widget.theme.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    final result = await _service.verifyOtp(_phone, otp, requestId: _requestId);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success && result.verified == true) {
      if (widget.theme.enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }

      final verificationResult = PhoneVerificationResult.success(
        _phone,
        requestId: _requestId,
      );

      widget.onVerificationComplete?.call(verificationResult);
      Navigator.of(context).pop(verificationResult);
    } else {
      setState(() {
        _error = _mapErrorMessage(result.errorCode, result.error);
      });
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0 ||
        _resendAttempts >= widget.config.maxResendAttempts) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _resendAttempts++;
    });

    OtpSendResult result;
    if (_requestId != null) {
      result = await _service.resendOtp(_requestId!);
    } else {
      result = await _service.sendOtp(_phone);
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result.success) {
        _requestId = result.requestId;
        _otpController.clear();
        _startResendCountdown();
      } else {
        _error = _mapErrorMessage(result.errorCode, result.error);
      }
    });
  }

  void _startResendCountdown() {
    _resendCountdown = widget.config.resendCooldownSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _mapErrorMessage(String? code, String? defaultMessage) {
    switch (code) {
      case 'RATE_LIMITED':
        return widget.translations.rateLimitMessage;
      case 'INVALID_PHONE':
        return widget.translations.invalidPhoneMessage;
      case 'EXPIRED':
        return widget.translations.expiredOtpMessage;
      case 'INVALID_OTP':
        return widget.translations.invalidOtpMessage;
      case 'NETWORK_ERROR':
        return widget.translations.networkErrorMessage;
      case 'MAX_ATTEMPTS':
        return widget.translations.maxAttemptsMessage;
      default:
        return defaultMessage ?? widget.translations.networkErrorMessage;
    }
  }

  void _cancel() {
    final result = PhoneVerificationResult.cancelled(_phone);
    widget.onVerificationComplete?.call(result);
    Navigator.of(context).pop(result);
  }

  void _changePhone() {
    setState(() {
      _otpSent = false;
      _error = null;
      _otpController.clear();
      _countdownTimer?.cancel();
      _resendCountdown = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Directionality(
        textDirection: widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: 24,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: widget.theme.backgroundColor,
              borderRadius: BorderRadius.circular(widget.theme.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: widget.theme.dialogPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    if (_otpSent) _buildOtpInput() else _buildPhoneInput(),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      _buildError(),
                    ],
                    const SizedBox(height: 24),
                    _buildButtons(),
                    if (widget.footerWidget != null) ...[
                      const SizedBox(height: 16),
                      widget.footerWidget!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        if (widget.headerWidget != null)
          widget.headerWidget!
        else if (widget.theme.showPhoneIcon)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.theme.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _otpSent ? Icons.sms_rounded : widget.theme.phoneIcon,
              size: 40,
              color: widget.theme.primaryColor,
            ),
          ),
        const SizedBox(height: 20),
        Text(
          widget.translations.title,
          style: widget.theme.titleStyle ??
              TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.theme.textColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _otpSent
              ? '${widget.translations.enterOtpMessage}\n$_phone'
              : widget.translations.subtitle,
          style: widget.theme.subtitleStyle ??
              TextStyle(
                fontSize: 14,
                color: widget.theme.hintColor,
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    if (!widget.showPhoneInput && widget.phoneNumber != null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.theme.secondaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(widget.theme.inputRadius),
            border: Border.all(
              color: _error != null
                  ? widget.theme.errorColor.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.phone,
            textAlign: widget.isRtl ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              color: widget.theme.textColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.translations.phoneHint,
              hintStyle: TextStyle(
                color: widget.theme.hintColor,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: widget.theme.hintColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
            ],
            onSubmitted: (_) => _sendOtp(),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: widget.theme.otpInputStyle ??
          TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.theme.textColor,
          ),
      decoration: BoxDecoration(
        color: widget.theme.secondaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(widget.theme.inputRadius),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Column(
      children: [
        Pinput(
          length: widget.config.otpLength,
          controller: _otpController,
          focusNode: _otpFocusNode,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: widget.theme.primaryColor, width: 2),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: widget.theme.errorColor, width: 2),
            ),
          ),
          onCompleted: (_) => _verifyOtp(),
          hapticFeedbackType: widget.theme.enableHapticFeedback
              ? HapticFeedbackType.lightImpact
              : HapticFeedbackType.disabled,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _changePhone,
              child: Text(
                widget.translations.changePhoneText,
                style: TextStyle(
                  color: widget.theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.config.allowResend) ...[
              const Text(' | '),
              _buildResendButton(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildResendButton() {
    final canResend = _resendCountdown == 0 &&
        _resendAttempts < widget.config.maxResendAttempts;

    if (_resendCountdown > 0) {
      return Text(
        widget.translations.formatResendCountdown(_resendCountdown),
        style: TextStyle(
          color: widget.theme.hintColor,
          fontSize: 14,
        ),
      );
    }

    if (_resendAttempts >= widget.config.maxResendAttempts) {
      return Text(
        widget.translations.maxAttemptsMessage,
        style: TextStyle(
          color: widget.theme.errorColor,
          fontSize: 12,
        ),
      );
    }

    return TextButton(
      onPressed: canResend ? _resendOtp : null,
      child: Text(
        widget.translations.resendButton,
        style: TextStyle(
          color: canResend ? widget.theme.primaryColor : widget.theme.hintColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.theme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.theme.inputRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: widget.theme.errorColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                color: widget.theme.errorColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : (_otpSent ? _verifyOtp : _sendOtp),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.theme.primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  widget.theme.primaryColor.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.theme.buttonRadius),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    _otpSent
                        ? widget.translations.verifyButton
                        : widget.translations.sendButton,
                    style: widget.theme.buttonTextStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isLoading ? null : _cancel,
          child: Text(
            widget.translations.cancelButton,
            style: TextStyle(
              color: widget.theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
