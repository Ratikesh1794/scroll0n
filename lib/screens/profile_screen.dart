import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'signin_phone_screen.dart';
import 'favourites_screen.dart';

/// Profile Screen
/// 
/// Displays user profile information and settings options
/// Based on Figma design with proper styling and layout
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF171717),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: null, // No selection - profile is independent
        onTap: _handleNavigation,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background blur effects
            _buildBackgroundEffects(),
            
            // Main content
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        // Top left blur effect
        Positioned(
          left: -103,
          top: 75,
          child: Container(
            width: 120,
            height: 172,
            decoration: BoxDecoration(
              color: const Color(0xFF033E4C).withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(100),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(),
            ),
          ),
        ),
        
        // Bottom right blur effect
        Positioned(
          left: 152,
          top: 465,
          child: Transform.rotate(
            angle: 21.58 * (3.14159 / 180), // Convert degrees to radians
            child: Container(
              width: 190,
              height: 401,
              decoration: BoxDecoration(
                color: const Color(0xFF033E4C).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(),
              ),
            ),
          ),
        ),
        
        // Bottom left blur effect
        Positioned(
          left: -122,
          top: 453,
          child: Transform.rotate(
            angle: -21.62 * (3.14159 / 180), // Convert degrees to radians
            child: Container(
              width: 190,
              height: 401,
              decoration: BoxDecoration(
                color: const Color(0xFF033E4C).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Profile title
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Profile',
              style: GoogleFonts.oswald(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEDEDED),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Profile section
          _buildProfileSection(),
          
          const SizedBox(height: 50),
          
          // Settings options
          _buildSettingsOptions(),
          
          const SizedBox(height: 32),
          
          // Logout button
          _buildLogoutButton(),
          
            const SizedBox(height: 80), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 94,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFF033E4C),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFFEDEDED),
              size: 45,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Profile info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFEDEDED).withValues(alpha: 0.75),
                ),
              ),
              Text(
                'Taibanana',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF033E4C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        _buildSettingsItem(
          'Language Settings',
          Icons.language,
          () {
            // TODO: Implement language settings
          },
        ),
        _buildSettingsItem(
          'Terms & Condition',
          Icons.description_outlined,
          () {
            // TODO: Implement terms & conditions
          },
        ),
        _buildSettingsItem(
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          () {
            // TODO: Implement privacy policy
          },
        ),
        _buildSettingsItem(
          'Help & Feedback',
          Icons.help_outline,
          () {
            // TODO: Implement help & feedback
          },
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 27,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.piazzolla(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                  color: const Color(0xFFEDEDED),
                ),
              ),
            ),
            Text(
              '>',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF033E4C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF4444).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _handleLogout,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: const Color(0xFFFF4444),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF4444),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        _navigateToHome();
        break;
      case 1:
        // Navigate to Browse/Explore
        // TODO: Implement browse screen navigation
        break;
      case 2:
        // Navigate to Search
        // TODO: Implement search screen navigation
        break;
      case 3:
        // Navigate to Favourites
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
        );
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEDEDED),
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFEDEDED).withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF033E4C),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to sign in screen and clear all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SigninPhoneScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF4444),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
