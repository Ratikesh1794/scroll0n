import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';

class FeaturedSection extends StatefulWidget {
  final List<Reel> featuredReels;
  final Function(String) onReelTap;

  const FeaturedSection({
    super.key,
    required this.featuredReels,
    required this.onReelTap,
  });

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _initAnimations();
    _startAutoScroll();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  void _startAutoScroll() {
    if (widget.featuredReels.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
        if (mounted) {
          _nextReel();
        }
      });
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _restartAutoScroll() {
    _stopAutoScroll();
    _startAutoScroll();
  }

  void _nextReel() {
    final nextIndex = (_currentIndex + 1) % widget.featuredReels.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _resetAndPlayAnimations();
    HapticFeedback.selectionClick();
  }

  void _resetAndPlayAnimations() {
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredReels.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768;
    final height = isTablet ? 520.0 : 460.0;

    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 32),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.featuredReels.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // Background Image with Overlay
              _buildBackgroundImage(index),
              
              // Content Overlay
              _buildContentOverlay(index, isTablet),
              
              // Page Indicators
              if (widget.featuredReels.length > 1)
                _buildPageIndicators(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage(int index) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.featuredReels[index].thumbnail),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: const [0.0, 0.4, 0.8],
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay(int index, bool isTablet) {
    return Positioned(
      left: isTablet ? 48 : 24,
      right: isTablet ? 48 : 24,
      bottom: isTablet ? 48 : 32,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Featured Badge
            _buildFeaturedBadge(isTablet),
            
            const SizedBox(height: 16),
            
            // Title
            _buildTitle(index, isTablet),
            
            const SizedBox(height: 12),
            
            // Metadata
            _buildMetadata(index, isTablet),
            
            const SizedBox(height: 16),
            
            // Description
            _buildDescription(index, isTablet),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(index, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBadge(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accentRed,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentRed.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'FEATURED',
        style: AppTheme.badgeText.copyWith(
          color: Colors.white,
          fontSize: isTablet ? 12 : 10,
        ),
      ),
    );
  }

  Widget _buildTitle(int index, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        widget.featuredReels[index].name,
        style: AppTheme.heroTitle.copyWith(
          fontSize: isTablet ? 42 : 32,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.8),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMetadata(int index, bool isTablet) {
    return Row(
      children: [
        _buildMetadataItem(
          Icons.calendar_today_outlined,
          widget.featuredReels[index].releaseDate,
          isTablet,
        ),
        const SizedBox(width: 24),
        _buildMetadataItem(
          Icons.access_time_outlined,
          widget.featuredReels[index].duration,
          isTablet,
        ),
      ],
    );
  }

  Widget _buildMetadataItem(IconData icon, String text, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isTablet ? 18 : 16,
          color: AppTheme.secondaryText,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTheme.metadataText.copyWith(
            fontSize: isTablet ? 16 : 14,
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(int index, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      child: Text(
        widget.featuredReels[index].description,
        style: AppTheme.descriptionText.copyWith(
          fontSize: isTablet ? 18 : 16,
          color: AppTheme.secondaryText,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons(int index, bool isTablet) {
    return Row(
      children: [
        // Play Button
        ElevatedButton.icon(
          onPressed: () {
            _stopAutoScroll();
            widget.onReelTap(widget.featuredReels[index].id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32 : 24,
              vertical: isTablet ? 16 : 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          icon: Icon(
            Icons.play_arrow,
            size: isTablet ? 24 : 20,
          ),
          label: Text(
            'Play',
            style: AppTheme.buttonText.copyWith(
              fontSize: isTablet ? 18 : 16,
              color: Colors.black,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // More Info Button
        OutlinedButton.icon(
          onPressed: () {
            _stopAutoScroll();
            widget.onReelTap(widget.featuredReels[index].id);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 2),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 20,
              vertical: isTablet ? 16 : 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.black.withValues(alpha: 0.3),
          ),
          icon: Icon(
            Icons.info_outline,
            size: isTablet ? 24 : 20,
          ),
          label: Text(
            'More Info',
            style: AppTheme.buttonTextSecondary.copyWith(
              fontSize: isTablet ? 18 : 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Positioned(
      bottom: 16,
      right: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.featuredReels.length,
          (index) => GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              _restartAutoScroll();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == _currentIndex ? 24 : 8,
              height: 4,
              decoration: BoxDecoration(
                color: index == _currentIndex
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}