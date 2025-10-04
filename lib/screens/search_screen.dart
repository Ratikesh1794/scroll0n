import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';
import 'browse_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';

/// Search Screen
/// 
/// Displays search interface with categories and language filters
/// Matches the design system used in home and favourites screens
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        // Navigate to Browse/Explore
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BrowseScreen()),
        );
        break;
      case 2:
        // Already on Search screen
        break;
      case 3:
        // Navigate to Favourites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
        );
        break;
    }
  }

  Widget _buildGenreCard(String title, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive width accounting for padding and spacing (same as browse_screen languages)
    final cardWidth = (screenWidth - (screenWidth * 0.04 * 2) - (screenWidth * 0.04)) / 2;
    final cardHeight = (screenHeight * 0.085).clamp(65.0, 90.0);
    
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black26,
                  child: Icon(
                    Icons.movie_outlined,
                    color: Colors.white54,
                    size: screenWidth * 0.08,
                  ),
                );
              },
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3 * 255),
                    Colors.black.withValues(alpha: 0.7 * 255),
                  ],
                ),
              ),
            ),
            // Title
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: (screenWidth * 0.05).clamp(18.0, 22.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String title, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive width accounting for padding and spacing (same as browse_screen languages)
    final cardWidth = (screenWidth - (screenWidth * 0.04 * 2) - (screenWidth * 0.04)) / 2;
    final cardHeight = (screenHeight * 0.085).clamp(65.0, 90.0);
    
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black26,
                  child: Icon(
                    Icons.language,
                    color: Colors.white54,
                    size: screenWidth * 0.08,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3 * 255),
                    Colors.black.withValues(alpha: 0.7 * 255),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: (screenWidth * 0.05).clamp(18.0, 22.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive sizing
    final profileIconSize = (screenWidth * 0.14).clamp(50.0, 64.0);
    final iconSize = (screenWidth * 0.07).clamp(26.0, 32.0);
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Search is selected
        onTap: _handleNavigation,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A2C32), // Very dark teal matching home screen
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with profile icon and title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: Container(
                        width: profileIconSize,
                        height: profileIconSize,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                          size: iconSize * 0.9,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white70,
                        size: iconSize,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'What do you want to watch',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Genres Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Genres',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'See more',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.accent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Wrap(
                          spacing: screenWidth * 0.04, // Must match the card width calculation gap
                          runSpacing: screenWidth * 0.04,
                          children: [
                            _buildGenreCard('ROMANCE', 'https://example.com/romance.jpg'),
                            _buildGenreCard('ACTION', 'https://example.com/action.jpg'),
                            _buildGenreCard('HORROR', 'https://example.com/horror.jpg'),
                            _buildGenreCard('COMEDY', 'https://example.com/comedy.jpg'),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Languages Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Languages',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'See more',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.accent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Wrap(
                          spacing: screenWidth * 0.04, // Must match the card width calculation gap
                          runSpacing: screenWidth * 0.04,
                          children: [
                            _buildLanguageCard('TELUGU', 'https://example.com/telugu.jpg'),
                            _buildLanguageCard('TAMIL', 'https://example.com/tamil.jpg'),
                            _buildLanguageCard('MALAYALAM', 'https://example.com/malayalam.jpg'),
                            _buildLanguageCard('KANNADA', 'https://example.com/kannada.jpg'),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.1), // Space for bottom navigation
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
