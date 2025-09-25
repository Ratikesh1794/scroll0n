import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

/// SHOTT Splash Screen - Clean Professional Design
/// 
/// Features:
/// - Elegant logo presentation with subtle effects
/// - Professional typography with smooth animations
/// - Clean particle system with refined aesthetics
/// - Smooth transitions and polished timing
/// - Minimalist visual effects focused on brand impact
/// - Professional visual storytelling
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
  // Clean Professional Controllers
  late AnimationController _masterController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  
  // Professional Logo Animations
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoGlowAnimation;
  
  // Clean Text Animations
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _taglineFadeAnimation;
  
  // Refined Background Effects
  late Animation<double> _particleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Master professional sequence - 3.5 seconds of polished experience
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    
    // Subtle background animation - gentle continuous movement
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    // Clean particle system
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Professional Logo Animations - Clean Elegant Entrance
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
    ));
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
    ));
    
    _logoGlowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeInOutSine),
    ));

    // Clean Professional Typography
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
    ));
    
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
    ));

    // Professional Subtitle
    _subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
    ));
    
    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.65, 0.9, curve: Curves.easeOutCubic),
    ));

    // Elegant Tagline
    _taglineFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.75, 0.95, curve: Curves.easeOut),
    ));


    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    // Professional Progress Animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Set status bar for professional appearance
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Start subtle background animation
    _backgroundController.repeat(reverse: true);
    
    // Start clean particle system
    _particleController.repeat();
    
    // Begin master professional sequence
    await _masterController.forward();
    
    // Brief pause for appreciation
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted && widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Subtle particle background
          _buildCleanParticleBackground(screenSize),
          
          // Main professional content
          SafeArea(
            child: Column(
              children: [
                // Main content area
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Professional Logo
                        _buildProfessionalLogo(isLargeScreen),
                        
                        SizedBox(height: isLargeScreen ? 60 : 48),
                        
                        // Clean Typography
                        _buildCleanTypography(isLargeScreen),
                      ],
                    ),
                  ),
                ),
                
                // Professional Loading Section
                _buildProfessionalLoadingSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds clean particle background
  Widget _buildCleanParticleBackground(Size screenSize) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: CleanParticlePainter(
            animationValue: _particleAnimation.value,
            screenSize: screenSize,
          ),
          child: Container(),
        );
      },
    );
  }

  /// Builds professional logo with elegant effects
  Widget _buildProfessionalLogo(bool isLargeScreen) {
    final logoSize = isLargeScreen ? 180.0 : 160.0;
    
    return AnimatedBuilder(
      animation: _masterController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoFadeAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(logoSize * 0.25),
                boxShadow: [
                  // Professional glow effect
                  BoxShadow(
                    color: AppTheme.shottGold.withValues(
                      alpha: 0.4 * _logoGlowAnimation.value,
                    ),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                  // Subtle depth shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(logoSize * 0.25),
                child: Stack(
                  children: [
                    // Base logo image
                    Image.asset(
                      'assets/app/shott-icon.png',
                      fit: BoxFit.cover,
                      width: logoSize,
                      height: logoSize,
                    ),
                    
                    // Professional overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    
                    // Clean border
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(logoSize * 0.25),
                        border: Border.all(
                          color: AppTheme.shottGold.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds clean professional typography
  Widget _buildCleanTypography(bool isLargeScreen) {
    return Column(
      children: [
        // Professional Brand Title
        AnimatedBuilder(
          animation: _masterController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _titleFadeAnimation,
              child: SlideTransition(
                position: _titleSlideAnimation,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        AppTheme.shottGold,
                        AppTheme.shottOrange,
                        AppTheme.shottGold,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'SHOTT',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 56 : 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: isLargeScreen ? 4.0 : 3.0,
                      shadows: [
                        Shadow(
                          color: AppTheme.shottGold.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: isLargeScreen ? 24 : 20),
        
        // Professional Subtitle
        AnimatedBuilder(
          animation: _masterController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _subtitleFadeAnimation,
              child: SlideTransition(
                position: _subtitleSlideAnimation,
                child: Text(
                  'Premium Short Content',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 20 : 18,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: isLargeScreen ? 16 : 12),
        
        // Clean Tagline
        AnimatedBuilder(
          animation: _masterController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _taglineFadeAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.shottGold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Stream • Discover • Experience',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 14 : 13,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.shottGold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds professional loading section
  Widget _buildProfessionalLoadingSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          // Clean progress bar
          AnimatedBuilder(
            animation: _masterController,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBackground.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 200 * _progressAnimation.value,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.shottGold,
                            AppTheme.shottOrange,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Professional loading text
          AnimatedBuilder(
            animation: _masterController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.6 + 0.3 * _progressAnimation.value,
                child: const Text(
                  'Loading premium experience...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.tertiaryText,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Clean particle painter for subtle background effects
class CleanParticlePainter extends CustomPainter {
  final double animationValue;
  final Size screenSize;
  
  CleanParticlePainter({
    required this.animationValue,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Create subtle floating particles
    for (int i = 0; i < 8; i++) {
      final x = (screenSize.width * 0.2) + 
                (screenSize.width * 0.6 * ((i * 0.618) % 1));
      final y = (screenSize.height * 0.3) + 
                (screenSize.height * 0.4 * ((i * 0.382) % 1));
      
      final offset = Offset(
        x + math.sin(animationValue * 2 * math.pi + i) * 15,
        y + math.cos(animationValue * 2 * math.pi + i * 0.7) * 10,
      );
      
      final opacity = 0.1 + 0.05 * math.sin(animationValue * 3 * math.pi + i);
      paint.color = AppTheme.shottGold.withValues(alpha: opacity);
      
      final radius = 1.5 + math.sin(animationValue * 4 * math.pi + i) * 0.5;
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
