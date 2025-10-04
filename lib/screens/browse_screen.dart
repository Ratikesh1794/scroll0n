import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../models/reel.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favourites_screen.dart';
import 'reel_overview_screen.dart';

/// Browse Screen
/// 
/// Displays curated content categories and trending content
/// Uses a unique radial gradient background with content cards
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<dynamic> _languages = [];
  List<dynamic> _trendingCategories = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBrowseData();
  }

  Future<void> _loadBrowseData() async {
    try {
      final String response = await rootBundle.loadString('data/dummydata/browse_data.json');
      final data = json.decode(response);
      
      if (mounted) {
        setState(() {
          _languages = data['languages'] as List;
          _trendingCategories = data['trending_categories'] as List;
          _categories = data['categories'] as List;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading browse data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load content. Please try again later.';
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
        // Already on Browse screen
        break;
      case 2:
        // Navigate to Search
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
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

  Widget _buildLanguageCard(Map<String, dynamic> language) {
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
              language['thumbnail'] as String,
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    language['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    language['count'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection(Map<String, dynamic> category) {
    final items = category['items'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    category['description'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Text(
                'See all',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
                        height: 200, // Match home screen height
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index] as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReelOverviewScreen(
                                      reel: Reel(
                                        id: item['id'] as String,
                                        name: item['name'] as String,
                                        description: item['description'] as String,
                                        thumbnail: item['thumbnail'] as String,
                                        videoUrl: item['videoUrl'] as String,
                                        releaseDate: item['releaseDate'] as String,
                                        duration: item['duration'] as String,
                                        episodes: (item['episodes'] as List?)?.map((e) => Episode.fromJson(e as Map<String, dynamic>)).toList() ?? [],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 296,
                                margin: EdgeInsets.only(right: index < items.length - 1 ? 16 : 0),
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
                                          item['thumbnail'] as String,
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
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item['name'] as String,
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
                                                      item['duration'] as String,
                                                      style: Theme.of(context).textTheme.labelMedium,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  item['releaseDate'] as String,
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
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'science':
        return Icons.science;
      case 'theater_comedy':
        return Icons.theater_comedy;
      case 'psychology':
        return Icons.psychology;
      case 'favorite':
        return Icons.favorite;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'movie':
        return Icons.movie;
      default:
        return Icons.category; // fallback icon
    }
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3 * 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.2 * 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconData(category['icon'] as String),
            color: AppTheme.accent,
          ),
        ),
        title: Text(
          category['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          category['count'] as String,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7 * 255),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white70,
        ),
        onTap: () {
          // Handle category selection
        },
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
        currentIndex: 1, // Browse is selected
        onTap: _handleNavigation,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.47, 0.38), // Based on Figma's 46.53%, 38.19%
            radius: 1.2,
            colors: [
              Color(0xFF2E2E2E),
              Color(0xFF282828),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                      'Browse',
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
              const SizedBox(height: 24),

              // Main content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white70,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _error = null;
                                      _isLoading = true;
                                    });
                                    _loadBrowseData();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.accent,
                                    side: const BorderSide(color: AppTheme.accent),
                                  ),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Languages Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Languages',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  Text(
                                    'See all',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: _languages
                                    .map((lang) => _buildLanguageCard(lang as Map<String, dynamic>))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Trending Categories
                            ..._trendingCategories.map((category) => Column(
                              children: [
                                _buildTrendingSection(category as Map<String, dynamic>),
                                const SizedBox(height: 32),
                              ],
                            )),

                            // Categories Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Categories',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  ..._categories.map((category) => _buildCategoryCard(category as Map<String, dynamic>)),
                                ],
                              ),
                            ),
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
}
