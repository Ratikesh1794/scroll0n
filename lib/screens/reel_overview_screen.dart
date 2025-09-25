import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';
import 'video_player_screen.dart';

/// Professional Reel Overview Screen
/// 
/// Displays detailed information about a selected reel including:
/// - Hero image/thumbnail with gradient overlay
/// - Title, description, duration, and release date
/// - Action buttons (Play, Add to Favorites, Share)
/// - Professional streaming platform design
class ReelOverviewScreen extends StatefulWidget {
  final Reel reel;

  const ReelOverviewScreen({
    super.key,
    required this.reel,
  });

  @override
  State<ReelOverviewScreen> createState() => _ReelOverviewScreenState();
}

class _ReelOverviewScreenState extends State<ReelOverviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isFavorited = false;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _playVideo() async {
    try {
      // Navigate to the professional video player screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(reel: widget.reel),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Failed to open video player: $e');
    }
  }


  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorited ? 'Added to favorites' : 'Removed from favorites',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        backgroundColor: AppTheme.surfaceBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareReel() {
    // TODO: Implement share functionality
    _showErrorSnackBar('Share functionality coming soon!');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: AppTheme.verticalThemeGradientDecoration,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              _buildHeroSection(),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.shottGold.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.primaryText,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.shottGold.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? AppTheme.accentRed : AppTheme.primaryText,
              size: 20,
            ),
            onPressed: _toggleFavorite,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isPlaying = true;
          });
          _playVideo();
          // Reset playing state after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _isPlaying = false;
              });
            }
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.reel.thumbnail),
              fit: BoxFit.cover,
              onError: (error, stackTrace) {
                // Handle image loading error
                debugPrint('Failed to load thumbnail: $error');
              },
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.primaryBackground.withValues(alpha: 0.3),
                  AppTheme.primaryBackground.withValues(alpha: 0.8),
                  AppTheme.primaryBackground,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Play button overlay
                Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildPlayButton(),
                  ),
                ),
                
                // Bottom gradient with title
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildHeroTitle(),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _playVideo,
      child: AnimatedScale(
        scale: _isPlaying ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.shottGold.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shottGold.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: AppTheme.primaryBackground,
                size: 40,
              ),
              // Subtle animation ring
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: _isPlaying ? 90 : 80,
                height: _isPlaying ? 90 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.shottGold.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeroTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.reel.name,
            style: AppTheme.heroTitle.copyWith(
              fontSize: 32,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(widget.reel.duration, Icons.access_time_rounded),
              const SizedBox(width: 12),
              _buildInfoChip(
                _formatReleaseDate(widget.reel.releaseDate),
                Icons.calendar_today_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.shottGold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.shottGold,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTheme.metadataText.copyWith(
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionButtons(),
              const SizedBox(height: 32),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildDetails(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildPrimaryButton(
            'Play Now',
            Icons.play_arrow_rounded,
            _playVideo,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSecondaryButton(
            'Share',
            Icons.share_rounded,
            _shareReel,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        text,
        style: AppTheme.buttonText.copyWith(
          color: isPrimary ? AppTheme.primaryBackground : AppTheme.primaryText,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppTheme.shottGold : AppTheme.surfaceBackground,
        foregroundColor: isPrimary ? AppTheme.primaryBackground : AppTheme.primaryText,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isPrimary ? Colors.transparent : AppTheme.shottGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        elevation: isPrimary ? 8 : 0,
        shadowColor: isPrimary ? AppTheme.shottGold.withValues(alpha: 0.3) : null,
      ),
    );
  }

  Widget _buildSecondaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: AppTheme.buttonTextSecondary.copyWith(
          color: AppTheme.primaryText,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryText,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        side: BorderSide(
          color: AppTheme.shottGold.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Synopsis',
          style: AppTheme.sectionHeader.copyWith(
            fontSize: 20,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceBackground.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.shottGold.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            widget.reel.description,
            style: AppTheme.descriptionText.copyWith(
              fontSize: 16,
              color: AppTheme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: AppTheme.sectionHeader.copyWith(
            fontSize: 20,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Duration', widget.reel.duration),
        const SizedBox(height: 12),
        _buildDetailRow('Release Date', _formatReleaseDate(widget.reel.releaseDate)),
        const SizedBox(height: 12),
        _buildDetailRow('Video ID', widget.reel.id.toUpperCase()),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.shottGold.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.cardSubtitle.copyWith(
              color: AppTheme.tertiaryText,
            ),
          ),
          Text(
            value,
            style: AppTheme.cardTitle.copyWith(
              fontSize: 14,
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  String _formatReleaseDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
