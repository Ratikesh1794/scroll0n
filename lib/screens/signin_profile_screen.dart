import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

/// Professional Profile Setup Screen
/// Collects user's name and creates their profile
class SigninProfileScreen extends StatefulWidget {
  final String phoneNumber;
  
  const SigninProfileScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<SigninProfileScreen> createState() => _SigninProfileScreenState();
}

class _SigninProfileScreenState extends State<SigninProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Auto-focus on name input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  bool get _isValidName {
    final name = _nameController.text.trim();
    return name.length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }

  String _formatName(String value) {
    // Capitalize first letter of each word
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _handleComplete() async {
    if (!_isValidName) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Save user's name to local storage
      final fullName = _nameController.text.trim();
      await UserService.saveUserName(fullName);
      await UserService.saveUserPhone(widget.phoneNumber);
      
      // Simulate API call to create profile
      await Future.delayed(const Duration(milliseconds: 1200));
      
      if (mounted) {
        // Navigate to home screen and clear navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
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
              // Header with back button - consistent with other screens
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
                        'What\'s your name?',
                        style: AppTheme.heroTitle.copyWith(
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Subtitle
                      Text(
                        'This will be displayed on your profile',
                        style: AppTheme.descriptionText.copyWith(
                          fontSize: 16,
                          color: AppTheme.tertiaryText,
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Name input section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FULL NAME',
                            style: AppTheme.badgeText.copyWith(
                              color: AppTheme.tertiaryText,
                              letterSpacing: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Name input - simplified to match other screens
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceBackground.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _nameFocus.hasFocus 
                                    ? AppTheme.accent 
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              style: AppTheme.cardTitle.copyWith(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                hintStyle: AppTheme.cardSubtitle.copyWith(
                                  color: AppTheme.tertiaryText,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Auto-format name as user types
                                  if (value != _formatName(value)) {
                                    _nameController.text = _formatName(value);
                                    _nameController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: _nameController.text.length),
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                          
                          // Name validation indicator
                          if (_nameController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    _isValidName ? Icons.check_circle : Icons.error,
                                    size: 16,
                                    color: _isValidName 
                                        ? AppTheme.successColor 
                                        : AppTheme.errorColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isValidName 
                                        ? 'Looks good!'
                                        : 'Please enter a valid name (at least 2 characters)',
                                    style: AppTheme.metadataText.copyWith(
                                      color: _isValidName 
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
                      
                      // Complete button - simplified to match other screens
                      Padding(
                        padding: EdgeInsets.only(bottom: keyboardHeight > 0 ? 16 : 32),
                        child: Column(
                          children: [
                            // Simple welcome text
                            Text(
                              'Welcome to SHOTT! Ready to discover premium content?',
                              style: AppTheme.metadataText.copyWith(
                                color: AppTheme.tertiaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Complete button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isValidName && !_isLoading ? _handleComplete : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isValidName 
                                      ? AppTheme.accent 
                                      : AppTheme.tertiaryText.withValues(alpha: 0.3),
                                  foregroundColor: _isValidName 
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
                                        'Complete Setup',
                                        style: AppTheme.buttonText.copyWith(
                                          color: _isValidName ? Colors.black : AppTheme.tertiaryText,
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
