import 'package:flutter/material.dart';
import '../models/reel.dart';
import '../models/category.dart';
import '../services/reel_service.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'reel_overview_screen.dart';
import 'profile_screen.dart';
import 'favourites_screen.dart';
import 'search_screen.dart';
import 'browse_screen.dart';
import 'notification_screen.dart';

/// SHOTT Home Screen - Main content area after splash
/// 
/// Features horizontal scrollable sections for each category
/// with vertical reel cards optimized for short-form content
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reel> _featuredReels = [];
  List<Reel> _recentReleases = [];
  List<Reel> _comingSoon = [];
  String _userFirstName = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUserName();
  }
  
  Future<void> _loadUserName() async {
    final firstName = await UserService.getFirstName();
    setState(() {
      _userFirstName = firstName;
    });
  }

  Future<void> _loadData() async {
    try {
      // Load featured reels for Most Popular section
      final featuredReels = await ReelService.loadFeaturedReels();
      
      // Load all reels data
      final reelData = await ReelService.loadReelData();
      
      // Get New Releases category for Recent Release section
      final newReleases = reelData.categories.firstWhere(
        (category) => category.name == "New Releases",
        orElse: () => Category(name: "", items: []),
      );

      // Get Action category for Coming Soon section (for demo)
      final action = reelData.categories.firstWhere(
        (category) => category.name == "Action",
        orElse: () => Category(name: "", items: []),
      );

      if (mounted) {
        setState(() {
          _featuredReels = featuredReels;
          _recentReleases = newReleases.items;
          _comingSoon = action.items;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Already on Home screen, do nothing
        break;
      case 1:
        // Navigate to Browse/Explore
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BrowseScreen()),
        );
        break;
      case 2:
        // Navigate to Search
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
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
        currentIndex: 0, // Home is selected
        onTap: _handleNavigation,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A2C32), // Very dark teal that matches the theme
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    // Profile section
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
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
                    SizedBox(width: screenWidth * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _userFirstName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
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
              SizedBox(height: screenHeight * 0.03),
            
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Most Popular Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: Text(
                          'Most Popular',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenHeight * 0.25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          itemCount: _featuredReels.length,
                          itemBuilder: (context, index) {
                            final reel = _featuredReels[index];
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
                                width: screenWidth * 0.75,
                                height: screenHeight * 0.25,
                                margin: EdgeInsets.only(right: index < _featuredReels.length - 1 ? screenWidth * 0.04 : 0),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    // Background Image with Error Handling
                                    Positioned.fill(
                                      child: Image.network(
                                        reel.thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: Icon(
                                                Icons.movie_outlined,
                                                color: Colors.white54,
                                                size: 64,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Black overlay for text visibility
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 204), // 0.8 * 255 ≈ 204
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            reel.name,
                                            style: Theme.of(context).textTheme.titleLarge,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    reel.duration,
                                                    style: Theme.of(context).textTheme.labelMedium,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                reel.releaseDate,
                                                style: Theme.of(context).textTheme.labelMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Recent Release Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Release',
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
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenHeight * 0.27,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          itemCount: _recentReleases.length,
                          itemBuilder: (context, index) {
                            final reel = _recentReleases[index];
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
                                width: screenWidth * 0.32,
                                margin: EdgeInsets.only(right: index < _recentReleases.length - 1 ? screenWidth * 0.04 : 0),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: screenWidth * 0.48,
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
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: Icon(
                                                Icons.movie_outlined,
                                                color: Colors.white54,
                                                size: 48,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
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
                      SizedBox(height: screenHeight * 0.03),

                      // Coming Soon Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Coming Soon',
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
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.1), // Add padding for nav bar
                        child: SizedBox(
                          height: screenHeight * 0.27,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            itemCount: _comingSoon.length,
                            itemBuilder: (context, index) {
                            final reel = _comingSoon[index];
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
                                width: screenWidth * 0.32,
                                margin: EdgeInsets.only(right: index < _comingSoon.length - 1 ? screenWidth * 0.04 : 0),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: screenWidth * 0.48,
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
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: Icon(
                                                Icons.movie_outlined,
                                                color: Colors.white54,
                                                size: 48,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            color: Colors.black26,
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
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