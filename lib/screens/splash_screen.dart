import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// SHOTT Splash Screen - Minimal Professional Design
class SplashScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const SplashScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));
  }

  Future<void> _startAnimationSequence() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    await _masterController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted && widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              AppTheme.primary.withValues(alpha: 102), // 0.4 * 255 ≈ 102
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _masterController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Container(
                                width: isLargeScreen ? 120 : 100,
                                height: isLargeScreen ? 120 : 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accent.withValues(alpha: 51), // 0.2 * 255 ≈ 51
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    'assets/app/shott-icon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Brand Name
                              Text(
                                'SHOTT',
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 32 : 28,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Tagline
                              Text(
                                'Premium Short Content',
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 16 : 14,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: AnimatedBuilder(
                  animation: _masterController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 32,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: _progressAnimation.value * 255),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}