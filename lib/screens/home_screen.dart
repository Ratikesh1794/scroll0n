import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/reel_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_section.dart';
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
      final data = await ReelService.loadReelData();
      setState(() {
        _reelData = data;
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.shottGold.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and brand
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shottGold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/app/shott-icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SHOTT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryText,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          
          // Action buttons
          Row(
            children: [
              // Notifications
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBackground.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.shottGold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Profile
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBackground.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.shottGold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppTheme.primaryText,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
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
        itemCount: _reelData!.categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemBuilder: (context, index) {
          final category = _reelData!.categories[index];
          return CategorySection(
            category: category,
            onReelTap: _onReelTap,
          );
        },
      ),
    );
  }
}
