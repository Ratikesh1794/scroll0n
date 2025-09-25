import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/reel.dart';
import '../services/reel_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_section.dart';
import '../widgets/featured_section.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'reel_overview_screen.dart';

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
  ReelData? _reelData;
  List<Reel> _featuredReels = [];
  bool _isLoading = true;
  String? _error;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ReelService.loadReelData(),
        ReelService.loadFeaturedReels(),
      ]);
      
      setState(() {
        _reelData = results[0] as ReelData;
        _featuredReels = results[1] as List<Reel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load content: $e';
        _isLoading = false;
      });
    }
  }

  void _onReelTap(String reelId) {
    // Find the reel by ID from all categories and featured reels
    Reel? selectedReel = _findReelById(reelId);
    
    if (selectedReel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReelOverviewScreen(reel: selectedReel),
        ),
      );
    } else {
      debugPrint('Reel not found: $reelId');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reel not found'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Reel? _findReelById(String reelId) {
    // Check featured reels first
    for (final reel in _featuredReels) {
      if (reel.id == reelId) {
        return reel;
      }
    }
    
    // Check all categories
    if (_reelData != null) {
      for (final category in _reelData!.categories) {
        for (final reel in category.items) {
          if (reel.id == reelId) {
            return reel;
          }
        }
      }
    }
    
    return null;
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // TODO: Handle navigation based on index
    switch (index) {
      case 0:
        debugPrint('Home tapped');
        break;
      case 1:
        debugPrint('Search tapped');
        break;
      case 2:
        debugPrint('Favorites tapped');
        break;
      case 3:
        debugPrint('Profile tapped');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // App Bar
          SafeArea(
            bottom: false,
            child: _buildAppBar(),
          ),
          
          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.shottGold.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Light Creative Logo Section
          _buildLightLogo(),
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildLightLogo() {
    return Row(
      children: [
        // Light, Creative Logo Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.shottGold.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Center(
            child: _buildCreativeIcon(),
          ),
        ),
        
        const SizedBox(width: 14),
        
        // Clean Brand Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main brand name with subtle accent
            Row(
              children: [
                Text(
                  'SH',
                  style: AppTheme.brandDisplay.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: AppTheme.shottGold,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'TT',
                  style: AppTheme.brandDisplay.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            // Minimal tagline
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.shottGold.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                'STREAM',
                style: AppTheme.badgeText.copyWith(
                  fontSize: 9,
                  color: AppTheme.shottGold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreativeIcon() {
    // Try to load the asset first, fallback to creative icon if not available
    return Image.asset(
      'assets/app/shott-icon.png',
      width: 20,
      height: 20,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Creative fallback icon
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.shottGold,
                  width: 1.5,
                ),
              ),
            ),
            // Inner play triangle
            Icon(
              Icons.play_arrow_rounded,
              color: AppTheme.shottGold,
              size: 14,
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Enhanced Notifications Button
        _buildActionButton(
          icon: Icons.notifications_outlined,
          onTap: () {
            // TODO: Handle notifications
            debugPrint('Notifications tapped');
          },
        ),
        
        const SizedBox(width: 16),
        
        // Enhanced Profile Button
        _buildActionButton(
          icon: Icons.person_outline_rounded,
          onTap: () {
            // TODO: Handle profile
            debugPrint('Profile tapped');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.shottGold.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryText.withValues(alpha: 0.9),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.shottGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading amazing content...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.shottGold,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_reelData == null || _reelData!.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_outlined,
              color: AppTheme.tertiaryText,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No content available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.shottGold,
      backgroundColor: AppTheme.surfaceBackground,
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _reelData!.categories.length + (_featuredReels.isNotEmpty ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemBuilder: (context, index) {
          // Featured section at the top
          if (index == 0 && _featuredReels.isNotEmpty) {
            return FeaturedSection(
              featuredReels: _featuredReels,
              onReelTap: _onReelTap,
            );
          }
          
          // Regular category sections
          final categoryIndex = _featuredReels.isNotEmpty ? index - 1 : index;
          final category = _reelData!.categories[categoryIndex];
          return CategorySection(
            category: category,
            onReelTap: _onReelTap,
          );
        },
      ),
    );
  }
}

