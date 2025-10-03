import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import 'signin_profile_screen.dart';

/// Professional OTP Verification Screen
/// Clean design with 4-digit OTP input and auto-verification
class SigninOtpScreen extends StatefulWidget {
  final String phoneNumber;
  
  const SigninOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<SigninOtpScreen> createState() => _SigninOtpScreenState();
}

class _SigninOtpScreenState extends State<SigninOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus on first input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _currentOtp {
    return _controllers.map((controller) => controller.text).join();
  }

  bool get _isOtpComplete {
    return _currentOtp.length == 4;
  }

  void _onOtpChanged(String value, int index) {
    setState(() {
      _errorMessage = '';
    });

    if (value.isNotEmpty) {
      // Haptic feedback on input
      HapticFeedback.lightImpact();
      
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      }
    }

    // Update UI when OTP is complete
    if (_isOtpComplete) {
      // Haptic feedback when completing OTP
      HapticFeedback.mediumImpact();
    }
  }


  void _verifyOtp() async {
    if (!_isOtpComplete) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      // For demo, accept any 4-digit OTP
      if (_currentOtp.length == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SigninProfileScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid OTP. Please try again.';
          _clearOtp();
        });
      }
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _resendOtp() async {
    if (!_canResend) return;

    // Haptic feedback on resend
    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      _startResendTimer();
      _clearOtp();
      
      // Show enhanced success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Verification code sent successfully',
                  style: AppTheme.cardSubtitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: AppTheme.verticalThemeGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.primaryText,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Responsive spacing from top
                      SizedBox(height: screenHeight * 0.08),
                      
                      // Title - simplified to match phone screen
                      Text(
                        'Verify your phone',
                        style: AppTheme.heroTitle.copyWith(
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Subtitle - simplified design
                      RichText(
                        text: TextSpan(
                          style: AppTheme.descriptionText.copyWith(
                            fontSize: 16,
                            color: AppTheme.tertiaryText,
                          ),
                          children: [
                            const TextSpan(text: 'We\'ve sent a 4-digit code to '),
                            TextSpan(
                              text: '+91 ${widget.phoneNumber}',
                              style: const TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // OTP Input Section - simplified
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VERIFICATION CODE',
                            style: AppTheme.badgeText.copyWith(
                              color: AppTheme.tertiaryText,
                              letterSpacing: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // OTP Input Fields - simplified design
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 72,
                                height: 80,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: AppTheme.heroTitle.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: AppTheme.surfaceBackground.withValues(alpha: 0.6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: AppTheme.accent,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: AppTheme.errorColor,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) => _onOtpChanged(value, index),
                                  onTap: () {
                                    _controllers[index].selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _controllers[index].text.length,
                                    );
                                  },
                                  onSubmitted: (value) {
                                    if (index < 3 && value.isNotEmpty) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          
                          // Error message - simplified
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    size: 16,
                                    color: AppTheme.errorColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _errorMessage,
                                    style: AppTheme.metadataText.copyWith(
                                      color: AppTheme.errorColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Resend section - simplified to match phone screen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t receive the code? ',
                            style: AppTheme.metadataText.copyWith(
                              color: AppTheme.tertiaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: _canResend ? _resendOtp : null,
                            child: Text(
                              _canResend ? 'Resend' : 'Resend in ${_resendTimer}s',
                              style: AppTheme.metadataText.copyWith(
                                color: _canResend ? AppTheme.accent : AppTheme.tertiaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Continue button - similar to phone screen
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isOtpComplete && !_isLoading ? _verifyOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isOtpComplete 
                                  ? AppTheme.accent 
                                  : AppTheme.tertiaryText.withValues(alpha: 0.3),
                              foregroundColor: _isOtpComplete 
                                  ? Colors.black 
                                  : AppTheme.tertiaryText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : Text(
                                    'Verify Code',
                                    style: AppTheme.buttonText.copyWith(
                                      color: _isOtpComplete ? Colors.black : AppTheme.tertiaryText,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
