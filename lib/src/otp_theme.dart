import 'package:flutter/material.dart';

/// OTP Dialog Theme
/// Customizable theme for the OTP verification dialog
class OtpDialogTheme {
  /// Primary color for buttons and accents
  final Color primaryColor;

  /// Secondary color for backgrounds
  final Color secondaryColor;

  /// Error color for error messages
  final Color errorColor;

  /// Success color for success states
  final Color successColor;

  /// Background color of the dialog
  final Color backgroundColor;

  /// Text color for primary text
  final Color textColor;

  /// Text color for secondary/hint text
  final Color hintColor;

  /// Border radius for the dialog
  final double borderRadius;

  /// Border radius for buttons
  final double buttonRadius;

  /// Border radius for input fields
  final double inputRadius;

  /// Padding inside the dialog
  final EdgeInsets dialogPadding;

  /// Title text style
  final TextStyle? titleStyle;

  /// Subtitle text style
  final TextStyle? subtitleStyle;

  /// Button text style
  final TextStyle? buttonTextStyle;

  /// OTP input text style
  final TextStyle? otpInputStyle;

  /// Show phone icon
  final bool showPhoneIcon;

  /// Custom phone icon
  final IconData phoneIcon;

  /// Animation duration
  final Duration animationDuration;

  /// Enable haptic feedback
  final bool enableHapticFeedback;

  const OtpDialogTheme({
    this.primaryColor = const Color(0xFF6366F1),
    this.secondaryColor = const Color(0xFFEEF2FF),
    this.errorColor = const Color(0xFFEF4444),
    this.successColor = const Color(0xFF10B981),
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF1F2937),
    this.hintColor = const Color(0xFF9CA3AF),
    this.borderRadius = 24.0,
    this.buttonRadius = 12.0,
    this.inputRadius = 12.0,
    this.dialogPadding = const EdgeInsets.all(24),
    this.titleStyle,
    this.subtitleStyle,
    this.buttonTextStyle,
    this.otpInputStyle,
    this.showPhoneIcon = true,
    this.phoneIcon = Icons.phone_android_rounded,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableHapticFeedback = true,
  });

  /// Create a dark theme
  factory OtpDialogTheme.dark() {
    return const OtpDialogTheme(
      primaryColor: Color(0xFF818CF8),
      secondaryColor: Color(0xFF374151),
      errorColor: Color(0xFFF87171),
      successColor: Color(0xFF34D399),
      backgroundColor: Color(0xFF1F2937),
      textColor: Color(0xFFF9FAFB),
      hintColor: Color(0xFF9CA3AF),
    );
  }

  /// Create a green theme
  factory OtpDialogTheme.green() {
    return const OtpDialogTheme(
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFFD1FAE5),
      errorColor: Color(0xFFEF4444),
      successColor: Color(0xFF10B981),
    );
  }

  /// Create a purple theme
  factory OtpDialogTheme.purple() {
    return const OtpDialogTheme(
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFFEDE9FE),
      errorColor: Color(0xFFEF4444),
      successColor: Color(0xFF10B981),
    );
  }

  /// Create a blue theme
  factory OtpDialogTheme.blue() {
    return const OtpDialogTheme(
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFFDBEAFE),
      errorColor: Color(0xFFEF4444),
      successColor: Color(0xFF10B981),
    );
  }

  /// Copy with new values
  OtpDialogTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? errorColor,
    Color? successColor,
    Color? backgroundColor,
    Color? textColor,
    Color? hintColor,
    double? borderRadius,
    double? buttonRadius,
    double? inputRadius,
    EdgeInsets? dialogPadding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? buttonTextStyle,
    TextStyle? otpInputStyle,
    bool? showPhoneIcon,
    IconData? phoneIcon,
    Duration? animationDuration,
    bool? enableHapticFeedback,
  }) {
    return OtpDialogTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      borderRadius: borderRadius ?? this.borderRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      otpInputStyle: otpInputStyle ?? this.otpInputStyle,
      showPhoneIcon: showPhoneIcon ?? this.showPhoneIcon,
      phoneIcon: phoneIcon ?? this.phoneIcon,
      animationDuration: animationDuration ?? this.animationDuration,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }
}
