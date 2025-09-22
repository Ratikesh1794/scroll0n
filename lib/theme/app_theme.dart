import 'package:flutter/material.dart';

/// SHOTT App Theme - Inspired by premium OTT platforms like Netflix, Prime Video, Disney+
/// 
/// Color palette designed for premium streaming experience with dark themes
/// and vibrant accent colors for better video content visibility
class AppTheme {
  // Primary Brand Colors
  static const Color shottGold = Color(0xFFFFD700); // Golden accent like Prime Video
  static const Color shottOrange = Color(0xFFFF6B35); // Vibrant orange for CTAs
  
  // Background Colors (Netflix-inspired dark theme)
  static const Color primaryBackground = Color(0xFF000000); // Pure black like Netflix
  static const Color secondaryBackground = Color(0xFF1A1A1A); // Dark grey for cards
  static const Color surfaceBackground = Color(0xFF2D2D2D); // Lighter surface color
  static const Color cardBackground = Color(0xFF333333); // Card backgrounds
  
  // Text Colors
  static const Color primaryText = Color(0xFFFFFFFF); // Pure white
  static const Color secondaryText = Color(0xFFE5E5E5); // Light grey
  static const Color tertiaryText = Color(0xFFB3B3B3); // Medium grey
  static const Color disabledText = Color(0xFF737373); // Disabled grey
  
  // Accent Colors
  static const Color accentRed = Color(0xFFE50914); // Netflix red
  static const Color accentBlue = Color(0xFF00A8E1); // Prime blue
  static const Color accentPurple = Color(0xFF8A2BE2); // Premium purple
  static const Color accentGreen = Color(0xFF46D369); // Success green
  
  // System Colors
  static const Color errorColor = Color(0xFFFF4444);
  static const Color warningColor = Color(0xFFFFAA00);
  static const Color successColor = Color(0xFF00C851);
  static const Color infoColor = Color(0xFF33B5E5);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700), // Gold
      Color(0xFFFF6B35), // Orange
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000), // Black
      Color(0xFF1A1A1A), // Dark grey
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D2D2D),
      Color(0xFF1A1A1A),
    ],
  );

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: shottGold,
        secondary: shottOrange,
        surface: secondaryBackground,
        error: errorColor,
        onPrimary: primaryBackground,
        onSecondary: primaryBackground,
        onSurface: primaryText,
        onError: primaryText,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: primaryBackground,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      
      // Card Theme
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: shottGold,
          foregroundColor: primaryBackground,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: shottGold,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: shottGold, width: 2),
        ),
        hintStyle: const TextStyle(color: tertiaryText),
        labelStyle: const TextStyle(color: secondaryText),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: tertiaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: tertiaryText,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: tertiaryText,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryText,
        size: 24,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryBackground,
        selectedItemColor: shottGold,
        unselectedItemColor: tertiaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
  
  // Custom Decoration Helpers
  static BoxDecoration get primaryGradientDecoration {
    return const BoxDecoration(
      gradient: primaryGradient,
    );
  }
  
  static BoxDecoration get backgroundGradientDecoration {
    return const BoxDecoration(
      gradient: backgroundGradient,
    );
  }
  
  static BoxDecoration cardDecoration({double borderRadius = 12}) {
    return BoxDecoration(
      gradient: cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  // Custom Text Styles for specific use cases
  static const TextStyle splashTitle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: primaryText,
    letterSpacing: 2.0,
  );
  
  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: secondaryText,
    letterSpacing: 1.2,
  );
  
  static const TextStyle brandText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: shottGold,
    letterSpacing: 1.5,
  );

  // Enhanced splash screen text styles
  static const TextStyle cinematicTitle = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: primaryText,
    letterSpacing: 3.0,
    height: 1.1,
  );
  
  static const TextStyle premiumSubtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: secondaryText,
    letterSpacing: 1.5,
    height: 1.3,
  );
  
  static const TextStyle elegantTagline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: shottGold,
    letterSpacing: 1.2,
    height: 1.4,
  );
}
