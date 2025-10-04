import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'reel_overview_screen.dart';
import 'search_screen.dart';
import 'browse_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import '../models/reel.dart';

/// Favourites Screen
/// 
/// Displays user's favourite movies/reels and watch history
/// Similar UI design to Home screen with grid layout
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Reel> _favourites = [];
  List<Reel> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    try {
      final String response = await rootBundle.loadString('data/dummydata/favourites.json');
      final data = json.decode(response);
      
      debugPrint('Favourites data loaded successfully');
      debugPrint('Favourites count: ${(data['favourites'] as List).length}');
      debugPrint('History count: ${(data['history'] as List).length}');
      
      if (mounted) {
        setState(() {
          _favourites = (data['favourites'] as List)
              .map((item) => Reel.fromJson(item as Map<String, dynamic>))
              .toList();
          _history = (data['history'] as List)
              .map((item) => Reel.fromJson(item as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
        
        debugPrint('Favourites loaded: ${_favourites.length}');
        debugPrint('First favourite: ${_favourites.isNotEmpty ? _favourites[0].name : "none"}');
        debugPrint('First thumbnail: ${_favourites.isNotEmpty ? _favourites[0].thumbnail : "none"}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading favourites: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        // Navigate to Search
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 3:
        // Already on Favourites screen, do nothing
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Favourites is selected
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
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Main content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Favourites grid section
                            _buildFavouritesSection(),
                            
                            const SizedBox(height: 24),
                            
                            // My History section
                            if (_history.isNotEmpty) _buildHistorySection(),
                            
                            const SizedBox(height: 80), // Space for bottom navigation
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Profile icon - matching home screen style
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
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
          ),
          
          const SizedBox(width: 8),
          
          // Favourites title - matching home screen typography
          Text(
            'Favourites',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          
          const Spacer(),
          
          // Notification icon
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white70,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavouritesSection() {
    if (_favourites.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No favourites yet',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16, // Horizontal spacing between cards
        runSpacing: 16, // Vertical spacing between rows
        children: _favourites.map((reel) => _buildFavouriteCard(reel)).toList(),
      ),
    );
  }

  Widget _buildFavouriteCard(Reel reel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // 16 padding on each side + 16 gap
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReelOverviewScreen(reel: reel),
          ),
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Movie poster - matching home screen card style
            Container(
              width: cardWidth,
              height: cardWidth * 1.48, // 128:190 ratio
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  reel.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Image loading error for ${reel.name}: $error');
                    return Container(
                      color: Colors.black26,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.movie_outlined,
                              color: Colors.white54,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reel.name,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.black26,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Movie title - matching home screen typography
            Text(
              reel.name,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header - matching home screen style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My History',
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
        ),
        
        const SizedBox(height: 8),
        
        // History items (horizontal scroll) - matching home screen style
        SizedBox(
          height: 216,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final reel = _history[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReelOverviewScreen(reel: reel),
                    ),
                  );
                },
                child: Container(
                  width: 128,
                  margin: EdgeInsets.only(right: index < _history.length - 1 ? 16 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            reel.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('History image loading error for ${reel.name}: $error');
                              return Container(
                                color: Colors.black26,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.movie_outlined,
                                        color: Colors.white54,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          reel.name,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.black26,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          reel.name,
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
