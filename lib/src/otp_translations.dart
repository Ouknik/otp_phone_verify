/// OTP Translations - Multi-language support
/// Users can customize all text strings used in the dialog

class OtpTranslations {
  /// Title shown at the top of the dialog
  final String title;

  /// Subtitle explaining what to do
  final String subtitle;

  /// Phone number input placeholder
  final String phoneHint;

  /// Phone number input label
  final String phoneLabel;

  /// Send OTP button text
  final String sendButton;

  /// Verify OTP button text
  final String verifyButton;

  /// Resend OTP button text
  final String resendButton;

  /// Cancel button text
  final String cancelButton;

  /// Change phone number link text
  final String changePhoneText;

  /// OTP sent success message
  final String otpSentMessage;

  /// OTP verified success message
  final String verifiedMessage;

  /// Invalid OTP error message
  final String invalidOtpMessage;

  /// Expired OTP error message
  final String expiredOtpMessage;

  /// Network error message
  final String networkErrorMessage;

  /// Rate limit error message
  final String rateLimitMessage;

  /// Invalid phone number message
  final String invalidPhoneMessage;

  /// Enter OTP instruction
  final String enterOtpMessage;

  /// Resend countdown text (use {seconds} as placeholder)
  final String resendCountdownText;

  /// Loading text
  final String loadingText;

  /// Verification in progress text
  final String verifyingText;

  /// Sending OTP text
  final String sendingText;

  /// Max attempts reached message
  final String maxAttemptsMessage;

  /// App name (shown in OTP message)
  final String appName;

  const OtpTranslations({
    this.title = 'Phone Verification',
    this.subtitle = 'We will send you a verification code',
    this.phoneHint = 'Enter phone number',
    this.phoneLabel = 'Phone Number',
    this.sendButton = 'Send Code',
    this.verifyButton = 'Verify',
    this.resendButton = 'Resend Code',
    this.cancelButton = 'Cancel',
    this.changePhoneText = 'Change phone number',
    this.otpSentMessage = 'Verification code sent successfully',
    this.verifiedMessage = 'Phone number verified successfully!',
    this.invalidOtpMessage = 'Invalid verification code',
    this.expiredOtpMessage = 'Code has expired. Please request a new one',
    this.networkErrorMessage = 'Network error. Please check your connection',
    this.rateLimitMessage = 'Too many attempts. Please wait before trying again',
    this.invalidPhoneMessage = 'Please enter a valid phone number',
    this.enterOtpMessage = 'Enter the 6-digit code sent to',
    this.resendCountdownText = 'Resend in {seconds}s',
    this.loadingText = 'Please wait...',
    this.verifyingText = 'Verifying...',
    this.sendingText = 'Sending...',
    this.maxAttemptsMessage = 'Maximum attempts reached. Please try again later',
    this.appName = 'App',
  });

  /// Arabic translations
  factory OtpTranslations.arabic({String? appName}) {
    return OtpTranslations(
      title: 'تأكيد رقم الهاتف',
      subtitle: 'سنرسل لك رمز التحقق',
      phoneHint: 'أدخل رقم الهاتف',
      phoneLabel: 'رقم الهاتف',
      sendButton: 'إرسال الرمز',
      verifyButton: 'تأكيد',
      resendButton: 'إعادة الإرسال',
      cancelButton: 'إلغاء',
      changePhoneText: 'تغيير رقم الهاتف',
      otpSentMessage: 'تم إرسال رمز التحقق بنجاح',
      verifiedMessage: 'تم التحقق من رقم الهاتف بنجاح!',
      invalidOtpMessage: 'رمز التحقق غير صحيح',
      expiredOtpMessage: 'انتهت صلاحية الرمز. يرجى طلب رمز جديد',
      networkErrorMessage: 'خطأ في الاتصال. يرجى التحقق من الإنترنت',
      rateLimitMessage: 'محاولات كثيرة. يرجى الانتظار قبل المحاولة مرة أخرى',
      invalidPhoneMessage: 'يرجى إدخال رقم هاتف صحيح',
      enterOtpMessage: 'أدخل الرمز المكون من 6 أرقام المرسل إلى',
      resendCountdownText: 'إعادة الإرسال بعد {seconds} ثانية',
      loadingText: 'يرجى الانتظار...',
      verifyingText: 'جاري التحقق...',
      sendingText: 'جاري الإرسال...',
      maxAttemptsMessage: 'تم الوصول للحد الأقصى من المحاولات. حاول لاحقاً',
      appName: appName ?? 'التطبيق',
    );
  }

  /// French translations
  factory OtpTranslations.french({String? appName}) {
    return OtpTranslations(
      title: 'Vérification du téléphone',
      subtitle: 'Nous vous enverrons un code de vérification',
      phoneHint: 'Entrez le numéro de téléphone',
      phoneLabel: 'Numéro de téléphone',
      sendButton: 'Envoyer le code',
      verifyButton: 'Vérifier',
      resendButton: 'Renvoyer le code',
      cancelButton: 'Annuler',
      changePhoneText: 'Changer le numéro',
      otpSentMessage: 'Code de vérification envoyé avec succès',
      verifiedMessage: 'Numéro de téléphone vérifié avec succès!',
      invalidOtpMessage: 'Code de vérification invalide',
      expiredOtpMessage: 'Le code a expiré. Veuillez en demander un nouveau',
      networkErrorMessage: 'Erreur réseau. Vérifiez votre connexion',
      rateLimitMessage: 'Trop de tentatives. Veuillez patienter',
      invalidPhoneMessage: 'Veuillez entrer un numéro valide',
      enterOtpMessage: 'Entrez le code à 6 chiffres envoyé à',
      resendCountdownText: 'Renvoyer dans {seconds}s',
      loadingText: 'Veuillez patienter...',
      verifyingText: 'Vérification...',
      sendingText: 'Envoi...',
      maxAttemptsMessage: 'Nombre maximum de tentatives atteint',
      appName: appName ?? 'App',
    );
  }

  /// Spanish translations
  factory OtpTranslations.spanish({String? appName}) {
    return OtpTranslations(
      title: 'Verificación de teléfono',
      subtitle: 'Te enviaremos un código de verificación',
      phoneHint: 'Ingresa el número de teléfono',
      phoneLabel: 'Número de teléfono',
      sendButton: 'Enviar código',
      verifyButton: 'Verificar',
      resendButton: 'Reenviar código',
      cancelButton: 'Cancelar',
      changePhoneText: 'Cambiar número',
      otpSentMessage: 'Código de verificación enviado exitosamente',
      verifiedMessage: 'Número de teléfono verificado exitosamente!',
      invalidOtpMessage: 'Código de verificación inválido',
      expiredOtpMessage: 'El código ha expirado. Por favor solicita uno nuevo',
      networkErrorMessage: 'Error de red. Verifica tu conexión',
      rateLimitMessage: 'Demasiados intentos. Por favor espera',
      invalidPhoneMessage: 'Por favor ingresa un número válido',
      enterOtpMessage: 'Ingresa el código de 6 dígitos enviado a',
      resendCountdownText: 'Reenviar en {seconds}s',
      loadingText: 'Por favor espera...',
      verifyingText: 'Verificando...',
      sendingText: 'Enviando...',
      maxAttemptsMessage: 'Máximo de intentos alcanzado',
      appName: appName ?? 'App',
    );
  }

  /// Copy with custom values
  OtpTranslations copyWith({
    String? title,
    String? subtitle,
    String? phoneHint,
    String? phoneLabel,
    String? sendButton,
    String? verifyButton,
    String? resendButton,
    String? cancelButton,
    String? changePhoneText,
    String? otpSentMessage,
    String? verifiedMessage,
    String? invalidOtpMessage,
    String? expiredOtpMessage,
    String? networkErrorMessage,
    String? rateLimitMessage,
    String? invalidPhoneMessage,
    String? enterOtpMessage,
    String? resendCountdownText,
    String? loadingText,
    String? verifyingText,
    String? sendingText,
    String? maxAttemptsMessage,
    String? appName,
  }) {
    return OtpTranslations(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      phoneHint: phoneHint ?? this.phoneHint,
      phoneLabel: phoneLabel ?? this.phoneLabel,
      sendButton: sendButton ?? this.sendButton,
      verifyButton: verifyButton ?? this.verifyButton,
      resendButton: resendButton ?? this.resendButton,
      cancelButton: cancelButton ?? this.cancelButton,
      changePhoneText: changePhoneText ?? this.changePhoneText,
      otpSentMessage: otpSentMessage ?? this.otpSentMessage,
      verifiedMessage: verifiedMessage ?? this.verifiedMessage,
      invalidOtpMessage: invalidOtpMessage ?? this.invalidOtpMessage,
      expiredOtpMessage: expiredOtpMessage ?? this.expiredOtpMessage,
      networkErrorMessage: networkErrorMessage ?? this.networkErrorMessage,
      rateLimitMessage: rateLimitMessage ?? this.rateLimitMessage,
      invalidPhoneMessage: invalidPhoneMessage ?? this.invalidPhoneMessage,
      enterOtpMessage: enterOtpMessage ?? this.enterOtpMessage,
      resendCountdownText: resendCountdownText ?? this.resendCountdownText,
      loadingText: loadingText ?? this.loadingText,
      verifyingText: verifyingText ?? this.verifyingText,
      sendingText: sendingText ?? this.sendingText,
      maxAttemptsMessage: maxAttemptsMessage ?? this.maxAttemptsMessage,
      appName: appName ?? this.appName,
    );
  }

  /// Format resend countdown text with seconds
  String formatResendCountdown(int seconds) {
    return resendCountdownText.replaceAll('{seconds}', seconds.toString());
  }
}
