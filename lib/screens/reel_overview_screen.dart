import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'video_player_screen.dart';
import 'home_screen.dart';
import 'browse_screen.dart';
import 'search_screen.dart';
import 'favourites_screen.dart';

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

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        // Navigate to Browse
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BrowseScreen()),
          (route) => false,
        );
        break;
      case 2:
        // Navigate to Search
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SearchScreen()),
          (route) => false,
        );
        break;
      case 3:
        // Navigate to Favourites
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: ReelOverviewTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: null, // No tab is selected on overview screen
        onTap: _handleNavigation,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight,
          child: Stack(
            children: [
              _buildHeroSection(),
              _buildSynopsisCard(),
              _buildChaptersSection(),
              _buildTopNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = (screenWidth * 0.055).clamp(20.0, 24.0);
    
    return Positioned(
      top: screenHeight * 0.07,
      left: screenWidth * 0.04,
      right: screenWidth * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ReelOverviewTheme.primaryText,
              size: iconSize,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? Colors.red : ReelOverviewTheme.primaryText,
                  size: iconSize,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              GestureDetector(
                onTap: _shareReel,
                child: Icon(
                  Icons.share,
                  color: ReelOverviewTheme.primaryText,
                  size: iconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: SizedBox(
        height: screenHeight * 0.38,
        child: Image.network(
          widget.reel.thumbnail,
          fit: BoxFit.cover,
        ),
      ),
    );
  }






  Widget _buildSynopsisCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      top: screenHeight * 0.325,
      left: screenWidth * 0.04,
      right: screenWidth * 0.04,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
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
                          fontSize: (screenWidth * 0.06).clamp(20.0, 26.0),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildRating(),
                        SizedBox(width: screenWidth * 0.04),
                        _buildViewCount(),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                // Synopsis section
                Text(
                  'Synopsis',
                  style: GoogleFonts.oswald(
                    fontSize: (screenWidth * 0.045).clamp(16.0, 20.0),
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  widget.reel.description,
                  style: GoogleFonts.poppins(
                    fontSize: (screenWidth * 0.028).clamp(10.0, 12.0),
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.45,
                  ),
                  maxLines: _isDescriptionExpanded ? null : 4,
                  overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
          // Show More/Less Button
          Transform.translate(
            offset: Offset(0, -screenHeight * 0.03),
            child: _buildShowMoreButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    final screenWidth = MediaQuery.of(context).size.width;
    final starSize = (screenWidth * 0.045).clamp(16.0, 20.0);
    
    return Row(
      children: [
        Container(
          width: starSize,
          height: starSize,
          decoration: BoxDecoration(
            color: Color(0xFFFFFF00), // Yellow star
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: Colors.black,
            size: starSize * 0.65,
          ),
        ),
        SizedBox(width: screenWidth * 0.01),
        Text(
          '7.9',
          style: GoogleFonts.poppins(
            fontSize: (screenWidth * 0.03).clamp(11.0, 13.0),
            fontWeight: FontWeight.w500,
            color: Color(0xFFEDEDED),
          ),
        ),
      ],
    );
  }

  Widget _buildViewCount() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Row(
      children: [
        Icon(
          Icons.visibility_outlined,
          color: Color(0xFFEDEDED),
          size: (screenWidth * 0.045).clamp(16.0, 20.0),
        ),
        SizedBox(width: screenWidth * 0.01),
        Text(
          '89,200',
          style: GoogleFonts.poppins(
            fontSize: (screenWidth * 0.03).clamp(11.0, 13.0),
            fontWeight: FontWeight.w500,
            color: Color(0xFFEDEDED),
          ),
        ),
      ],
    );
  }

  Widget _buildShowMoreButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth * 0.12).clamp(44.0, 52.0);
    
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDescriptionExpanded = !_isDescriptionExpanded;
          });
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
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
            size: buttonSize * 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildChaptersSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      top: _isDescriptionExpanded ? screenHeight * 0.595 : screenHeight * 0.545,
      left: screenWidth * 0.04,
      right: screenWidth * 0.04,
      bottom: screenHeight * 0.1, // Leave space for bottom navigation bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chapters',
            style: GoogleFonts.oswald(
              fontSize: (screenWidth * 0.06).clamp(20.0, 26.0),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final thumbnailSize = (screenWidth * 0.21).clamp(70.0, 90.0);
    
    return Container(
      height: (screenHeight * 0.12).clamp(85.0, 105.0),
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
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
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Row(
              children: [
                // Episode thumbnail
                Container(
                  width: thumbnailSize,
                  height: thumbnailSize * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      episode.thumbnail,
                      fit: BoxFit.cover,
                      width: thumbnailSize,
                      height: thumbnailSize * 0.95,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.035),
                // Episode details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chapter ${episode.episodeNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: (screenWidth * 0.03).clamp(11.0, 13.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEDEDED),
                        ),
                      ),
                      Text(
                        episode.name,
                        style: GoogleFonts.poppins(
                          fontSize: (screenWidth * 0.04).clamp(14.0, 17.0),
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



}

