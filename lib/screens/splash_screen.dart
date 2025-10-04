import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// SHOTT Splash Screen - Ultra Minimal Professional Design
/// 
/// Features a clean, sophisticated animation with the brand name as the focal point
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
  late AnimationController _glowController;
  late AnimationController _fadeController;
  late AnimationController _letterController;
  
  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _letterSpacingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Pulsing glow effect controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Main fade in controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Letter spacing animation controller
    _letterController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Smooth glow pulse
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Letter spacing animation - from wide to normal
    _letterSpacingAnimation = Tween<double>(
      begin: 20.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _letterController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Set system UI style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Delay before starting animations
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Start animations together
    _fadeController.forward();
    _letterController.forward();

    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 2000));

    // Complete callback
    if (mounted && widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _fadeController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Color.lerp(
                        const Color(0xFF0A1A1F),
                        AppTheme.primary,
                        _glowAnimation.value * 0.15,
                      )!,
                      const Color(0xFF000000),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              );
            },
          ),

          // Subtle animated particles/orbs
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                final offset = math.sin(_glowController.value * math.pi * 2 + index) * 0.3;
                return Positioned(
                  top: MediaQuery.of(context).size.height * (0.3 + offset * 0.2),
                  left: MediaQuery.of(context).size.width * (0.2 + index * 0.3),
                  child: Opacity(
                    opacity: 0.05 + (_glowAnimation.value * 0.05),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.accent.withValues(alpha: 51),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main content - SHOTT title
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeAnimation, _letterSpacingAnimation, _glowAnimation]),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main SHOTT title with glow
                      Stack(
                        children: [
                          // Glow layer
                          Text(
                            'ShoTT',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w700,
                              letterSpacing: _letterSpacingAnimation.value,
                              color: Colors.transparent,
                              shadows: [
                                Shadow(
                                  color: AppTheme.accent.withValues(
                                    alpha: _glowAnimation.value * 153, // 0.6 * 255
                                  ),
                                  blurRadius: 40,
                                ),
                                Shadow(
                                  color: AppTheme.shottGold.withValues(
                                    alpha: _glowAnimation.value * 102, // 0.4 * 255
                                  ),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          // Main text
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 230),
                                AppTheme.shottGold.withValues(alpha: 204),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              'ShoTT',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                letterSpacing: _letterSpacingAnimation.value,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Subtle underline with animation
                      Container(
                        width: 80 + (_fadeAnimation.value * 40),
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.accent.withValues(alpha: _fadeAnimation.value * 255),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}