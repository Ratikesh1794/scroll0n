import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';
import 'video_player_screen.dart';
import 'home_screen.dart';

// Custom theme constants based on Figma design
class ReelOverviewTheme {
  static const backgroundColor = Color(0xFF171717);
  static const primaryText = Color(0xFFEDEDED);
  static const secondaryText = Color(0x80EDEDED);
  static const accentColor = Color(0xFF033E4C);
  static const goldColor = Color(0xFFFFFF00);
  
  static final titleStyle = GoogleFonts.oswald(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: primaryText,
  );
  
  static final chapterTitleStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: accentColor,
  );
  
  static final chapterNumberStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: primaryText,
  );
  
  static final synopsisStyle = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: secondaryText,
  );
  
  static final metadataStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: primaryText,
  );
}

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

class _ReelOverviewScreenState extends State<ReelOverviewScreen> {
  bool _isFavorited = false;
  VideoPlayerController? _videoController;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _playVideo({Episode? episode}) async {
    try {
      // If episode is provided, play that specific episode
      // Otherwise, play the first episode
      final targetEpisode = episode ?? widget.reel.episodes.first;
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            reel: widget.reel,
            episode: targetEpisode,
          ),
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
      backgroundColor: ReelOverviewTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _buildHeroSection(),
              _buildSynopsisCard(),
              _buildChaptersSection(),
              _buildTopNavigation(),
              _buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Positioned(
      top: 56,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ReelOverviewTheme.primaryText,
                size: 20,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _toggleFavorite,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : ReelOverviewTheme.primaryText,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _shareReel,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.share,
                    color: ReelOverviewTheme.primaryText,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: SizedBox(
        height: 307,
        child: Image.network(
          widget.reel.thumbnail,
          fit: BoxFit.cover,
        ),
      ),
    );
  }






  Widget _buildSynopsisCard() {
    return Positioned(
      top: 262,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ReelOverviewTheme.backgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and ratings row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.reel.name,
                        style: GoogleFonts.oswald(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildRating(),
                        const SizedBox(width: 16),
                        _buildViewCount(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Synopsis section
                Text(
                  'Synopsis',
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.reel.description,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.45,
                  ),
                  maxLines: _isDescriptionExpanded ? null : 4,
                  overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16), // Space for button
              ],
            ),
          ),
          // Show More/Less Button
          Transform.translate(
            offset: const Offset(0, -24),
            child: _buildShowMoreButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Color(0xFFFFFF00), // Yellow star
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: Colors.black,
            size: 12,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '7.9',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEDEDED),
          ),
        ),
      ],
    );
  }

  Widget _buildViewCount() {
    return Row(
      children: [
        Icon(
          Icons.visibility_outlined,
          color: Color(0xFFEDEDED),
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          '89,200',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEDEDED),
          ),
        ),
      ],
    );
  }

  Widget _buildShowMoreButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDescriptionExpanded = !_isDescriptionExpanded;
          });
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF033E4C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            _isDescriptionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Color(0xFFEDEDED),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildChaptersSection() {
    return Positioned(
      top: _isDescriptionExpanded ? 550 : 500,
      left: 16,
      right: 16,
      bottom: 60, // Leave space for bottom navigation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chapters',
            style: GoogleFonts.oswald(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: widget.reel.episodes.map((episode) => 
                _buildChapterCard(episode, widget.reel.episodes.indexOf(episode))
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Episode episode, int index) {
    return Container(
      height: 96,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF033E4C),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playVideo(episode: episode),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Episode thumbnail
                Container(
                  width: 84,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      episode.thumbnail,
                      fit: BoxFit.cover,
                      width: 84,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                // Episode details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chapter ${episode.episodeNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEDEDED),
                        ),
                      ),
                      Text(
                        episode.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF033E4C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Color(0xFF033E4C),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavBarItem(Icons.home, true, () => _navigateToHome()),
              _buildNavBarItem(Icons.explore, false, null),
              _buildNavBarItem(Icons.search, false, null),
              _buildNavBarItem(Icons.favorite_border, false, null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, bool isSelected, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Icon(
          icon,
          color: isSelected 
            ? Color(0xFFEDEDED)
            : Color(0xFFEDEDED).withValues(alpha: 0.75),
          size: 24,
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }


}

