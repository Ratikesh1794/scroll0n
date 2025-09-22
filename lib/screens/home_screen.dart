import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/reel.dart';
import '../services/reel_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_section.dart';
import '../widgets/featured_section.dart';
import '../widgets/bottom_navigation_bar.dart';

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
    // TODO: Navigate to reel player
    debugPrint('Tapped reel: $reelId');
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
      body: Container(
        decoration: AppTheme.backgroundGradientDecoration,
        child: Column(
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
        color: AppTheme.primaryBackground.withValues(alpha: 0.98),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.shottGold.withValues(alpha: 0.08),
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
            color: AppTheme.shottGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.shottGold.withValues(alpha: 0.3),
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
                const Text(
                  'SH',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryText,
                    letterSpacing: 1.0,
                    height: 1.0,
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
                const Text(
                  'TT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryText,
                    letterSpacing: 1.0,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            // Minimal tagline
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.shottGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'STREAM',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.shottGold,
                  letterSpacing: 1.5,
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
          color: AppTheme.surfaceBackground.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.shottGold.withValues(alpha: 0.2),
            width: 0.8,
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.shottGold,
            ),
            SizedBox(height: 16),
            Text(
              'Loading amazing content...',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 16,
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
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 16,
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              color: AppTheme.tertiaryText,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No content available',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 14,
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

