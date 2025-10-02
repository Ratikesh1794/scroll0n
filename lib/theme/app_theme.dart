import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SHOTT App Theme - Inspired by premium OTT platforms like Netflix, Prime Video, Disney+
/// 
/// Color palette designed for premium streaming experience with dark themes
/// and vibrant accent colors for better video content visibility
class AppTheme {
  // Primary Brand Colors
  static const Color primary = Color(0xFF033E4C); // Menu bar background color from Figma
  static const Color background = Color(0xFF171717); // Main background color
  static const Color accent = Color(0xFF33B5E5); // Accent blue
  
  // Legacy color names mapped to new scheme (for backward compatibility)
  static const Color shottGold = accent; // Mapped to accent blue
  static const Color shottOrange = Color(0xFF1A2C32); // Mapped to dark teal
  static const Color accentRed = Color(0xFF33B5E5); // Mapped to accent blue
  
  // Background Colors
  static const Color primaryBackground = Color(0xFF000000); // Pure black
  static const Color secondaryBackground = Color(0xFF1A2C32); // Dark teal
  static const Color surfaceBackground = Color(0xFF2D2D2D); // Surface color
  static const Color cardBackground = Colors.white; // Card backgrounds
  
  // Text Colors
  static const Color primaryText = Color(0xFFEDEDED); // Main text color
  static const Color secondaryText = Color(0xBFEDEDED); // 75% opacity text
  static const Color tertiaryText = Color(0xFFB3B3B3); // Medium grey
  static const Color disabledText = Color(0xFF737373); // Disabled grey
  
  // Accent Colors
  static const Color accentLight = Color(0xFF33B5E5); // Light blue
  static const Color accentDark = Color(0xFF1A2C32); // Dark teal
  static const Color accentMuted = Color(0xFF4A5C62); // Muted teal
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
      Color(0xFF33B5E5), // Light blue
      Color(0xFF1A2C32), // Dark teal
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000), // Black
      Color(0xFF1A2C32), // Dark teal
    ],
  );
  
  // New vertical gradient with theme color at top and black at bottom
  static const LinearGradient verticalThemeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000), // Pure black
      Color(0xFF1A2C32), // Dark teal
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D2D2D),
      Color(0xFF1A2C32),
    ],
  );

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentMuted,
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
          backgroundColor: accent,
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
          foregroundColor: accent,
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
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        hintStyle: const TextStyle(color: tertiaryText),
        labelStyle: const TextStyle(color: secondaryText),
      ),
      
      // Professional Typography System
      textTheme: _buildTypographySystem(),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryText,
        size: 24,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primary,
        selectedItemColor: primaryText,
        unselectedItemColor: primaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // We'll handle shadow with decoration
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
  
  static BoxDecoration get verticalThemeGradientDecoration {
    return const BoxDecoration(
      gradient: verticalThemeGradient,
    );
  }
  
  static BoxDecoration cardDecoration({double borderRadius = 12}) {
    return BoxDecoration(
      gradient: cardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 77),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Custom Text Styles for specific use cases
  static TextStyle get heroTitle {
    return GoogleFonts.inter(
      fontSize: 42,
      fontWeight: FontWeight.w800,
      color: primaryText,
      letterSpacing: -1.0,
      height: 1.1,
    );
  }

  static TextStyle get sectionHeader {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: primaryText,
      letterSpacing: -0.3,
      height: 1.2,
    );
  }

  static TextStyle get cardTitle {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryText,
      letterSpacing: 0,
      height: 1.3,
    );
  }

  static TextStyle get cardSubtitle {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: secondaryText,
      letterSpacing: 0.2,
      height: 1.4,
    );
  }

  static TextStyle get buttonText {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryBackground,
      letterSpacing: 0.3,
      height: 1.2,
    );
  }

  static TextStyle get buttonTextSecondary {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: accent,
      letterSpacing: 0.3,
      height: 1.2,
    );
  }

  static TextStyle get navigationLabel {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: tertiaryText,
      letterSpacing: 0.4,
      height: 1.2,
    );
  }

  static TextStyle get navigationLabelSelected {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: accent,
      letterSpacing: 0.4,
      height: 1.2,
    );
  }

  static TextStyle get metadataText {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: tertiaryText,
      letterSpacing: 0.3,
      height: 1.3,
    );
  }

  static TextStyle get badgeText {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: primaryText,
      letterSpacing: 1.2,
      height: 1.0,
    );
  }

  static TextStyle get descriptionText {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: secondaryText,
      letterSpacing: 0.1,
      height: 1.5,
    );
  }

  static TextStyle get premiumText {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: accent,
      letterSpacing: 0.5,
      height: 1.3,
    );
  }
  
  // Professional Typography System
  static TextTheme _buildTypographySystem() {
    return TextTheme(
      // Section Headers (Most Popular, Recent Release, Coming Soon)
      headlineMedium: GoogleFonts.oswald(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.333333,
      ),
      // Movie titles in cards
      titleLarge: GoogleFonts.oswald(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.333333,
        shadows: [
          Shadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 128),
          ),
        ],
      ),
      // Good Morning text
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        letterSpacing: -0.333333,
      ),
      // Username text
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: accent,
        letterSpacing: -0.333333,
      ),
      // Movie details, See more
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryText,
        letterSpacing: -0.333333,
      ),
      // Other styles inherited from base theme
      displayLarge: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: primaryText,
        letterSpacing: -1.2,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: primaryText,
        letterSpacing: -0.8,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryText,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0,
        height: 1.35,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: tertiaryText,
        letterSpacing: 0.2,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        letterSpacing: 0.2,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
        letterSpacing: 0.2,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: tertiaryText,
        letterSpacing: 0.4,
        height: 1.4,
      ),
    );
  }
}