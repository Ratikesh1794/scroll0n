import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';
import 'browse_screen.dart';

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
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2, // Account for padding and gap
      height: 68,
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
                  child: const Icon(
                    Icons.movie_outlined,
                    color: Colors.white54,
                    size: 32,
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
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 20,
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
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      height: 68,
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
                  child: const Icon(
                    Icons.language,
                    color: Colors.white54,
                    size: 32,
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
                style: const TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 20,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white70,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              const SizedBox(height: 24),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildGenreCard('ROMANCE', 'https://example.com/romance.jpg'),
                            _buildGenreCard('ACTION', 'https://example.com/action.jpg'),
                            _buildGenreCard('HORROR', 'https://example.com/horror.jpg'),
                            _buildGenreCard('COMEDY', 'https://example.com/comedy.jpg'),
                          ],
                        ),
                        const SizedBox(height: 32),

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
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildLanguageCard('TELUGU', 'https://example.com/telugu.jpg'),
                            _buildLanguageCard('TAMIL', 'https://example.com/tamil.jpg'),
                            _buildLanguageCard('MALAYALAM', 'https://example.com/malayalam.jpg'),
                            _buildLanguageCard('KANNADA', 'https://example.com/kannada.jpg'),
                          ],
                        ),
                        const SizedBox(height: 80), // Space for bottom navigation
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
