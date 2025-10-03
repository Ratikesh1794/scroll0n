import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'signin_otp_screen.dart';

/// Professional Mobile Number Input Screen
/// Clean, minimal design focusing on phone number entry
class SigninPhoneScreen extends StatefulWidget {
  const SigninPhoneScreen({super.key});

  @override
  State<SigninPhoneScreen> createState() => _SigninPhoneScreenState();
}

class _SigninPhoneScreenState extends State<SigninPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Auto-focus on phone input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  bool get _isValidPhone {
    final phone = _phoneController.text.replaceAll(' ', '').replaceAll('-', '');
    return phone.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  void _handleContinue() async {
    if (!_isValidPhone) return;
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SigninOtpScreen(
            phoneNumber: _phoneController.text.trim(),
          ),
        ),
      );
    }
  }

  String _formatPhoneNumber(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 10 digits
    final limited = digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;
    
    // Format as XXXXX XXXXX
    if (limited.length <= 5) {
      return limited;
    } else {
      return '${limited.substring(0, 5)} ${limited.substring(5)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
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
                      // Spacing from top
                      SizedBox(height: screenHeight * 0.08),
                      
                      // Title
                      Text(
                        'Enter your phone number',
                        style: AppTheme.heroTitle.copyWith(
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Subtitle
                      Text(
                        'We\'ll send you a verification code',
                        style: AppTheme.descriptionText.copyWith(
                          fontSize: 16,
                          color: AppTheme.tertiaryText,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Phone input section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHONE NUMBER',
                            style: AppTheme.badgeText.copyWith(
                              color: AppTheme.tertiaryText,
                              letterSpacing: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Phone input with country code
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceBackground.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _phoneFocus.hasFocus 
                                    ? AppTheme.accent 
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Country code section
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '🇮🇳',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+91',
                                        style: AppTheme.cardTitle.copyWith(
                                          color: AppTheme.primaryText,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 1,
                                        height: 24,
                                        color: AppTheme.tertiaryText.withValues(alpha: 0.3),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Phone number input
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    focusNode: _phoneFocus,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: AppTheme.cardTitle.copyWith(
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter phone number',
                                      hintStyle: AppTheme.cardSubtitle.copyWith(
                                        color: AppTheme.tertiaryText,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _phoneController.text = _formatPhoneNumber(value);
                                        _phoneController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: _phoneController.text.length),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Phone validation indicator
                          if (_phoneController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    _isValidPhone ? Icons.check_circle : Icons.error,
                                    size: 16,
                                    color: _isValidPhone 
                                        ? AppTheme.successColor 
                                        : AppTheme.errorColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isValidPhone 
                                        ? 'Valid phone number'
                                        : 'Please enter a valid 10-digit phone number',
                                    style: AppTheme.metadataText.copyWith(
                                      color: _isValidPhone 
                                          ? AppTheme.successColor 
                                          : AppTheme.errorColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Continue button
                      Padding(
                        padding: EdgeInsets.only(bottom: keyboardHeight > 0 ? 16 : 32),
                        child: Column(
                          children: [
                            // Terms text
                            Text(
                              'By continuing, you agree to our Terms of Service and Privacy Policy',
                              style: AppTheme.metadataText.copyWith(
                                color: AppTheme.tertiaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Continue button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isValidPhone && !_isLoading ? _handleContinue : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isValidPhone 
                                      ? AppTheme.accent 
                                      : AppTheme.tertiaryText.withValues(alpha: 0.3),
                                  foregroundColor: _isValidPhone 
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
                                        'Continue',
                                        style: AppTheme.buttonText.copyWith(
                                          color: _isValidPhone ? Colors.black : AppTheme.tertiaryText,
                                        ),
                                      ),
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
      ),
    );
  }
}
