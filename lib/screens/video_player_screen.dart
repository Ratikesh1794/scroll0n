import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';

/// Professional Video Player Screen for Reels/Shorts (Instagram/YouTube Shorts Style)
/// 
/// Features:
/// - Portrait-only orientation optimized for short-form content
/// - Tap-to-show/hide controls with auto-hide timer (3 seconds)
/// - Side action buttons (Like, Favourites, Episodes, Share) - always visible
/// - Bottom info overlay showing episode/reel details - shows/hides with controls
/// - Top navigation with back button, title, and options
/// - Progress bar in controls overlay
/// - Professional OTT platform aesthetic with gradients and shadows
/// - Smooth animations and immersive full-screen experience
class VideoPlayerScreen extends StatefulWidget {
  final Reel reel;
  final Episode? episode;
  final List<Reel>? relatedReels;

  const VideoPlayerScreen({
    super.key,
    required this.reel,
    this.episode,
    this.relatedReels,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isBuffering = false;
  bool _isInFavourites = false;
  bool _isLiked = false;
  
  // Animation controllers
  late AnimationController _controlsAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _controlsOpacity;
  late Animation<double> _fadeAnimation;
  
  // Control visibility timer
  final Duration _controlsTimeout = const Duration(seconds: 3);
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideoPlayer();
    _setupControlsTimer();
    
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _initializeAnimations() {
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controlsOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));

    _controlsAnimationController.forward();
    _fadeAnimationController.forward();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // For demo purposes, we'll use a placeholder video
      // In production, you'd use widget.reel.videoUrl
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        // Auto-play the video
        _controller!.play();
        _isPlaying = true;
        
        // Listen for video state changes
        _controller!.addListener(_videoListener);
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to load video');
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;
    
    final isBuffering = _controller!.value.isBuffering;
    final isPlaying = _controller!.value.isPlaying;
    
    if (_isBuffering != isBuffering || _isPlaying != isPlaying) {
      setState(() {
        _isBuffering = isBuffering;
        _isPlaying = isPlaying;
      });
    }
  }

  void _setupControlsTimer() {
    Future.delayed(_controlsTimeout, () {
      if (mounted && _showControls && _isPlaying) {
        _hideControls();
      }
    });
  }

  void _showControlsOverlay() {
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
      _controlsAnimationController.forward();
      _setupControlsTimer();
    }
  }

  void _hideControls() {
    if (_showControls) {
      _controlsAnimationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      setState(() {
        if (_isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
      _showControlsOverlay();
    }
  }

  void _toggleFavourites() {
    setState(() {
      _isInFavourites = !_isInFavourites;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isInFavourites ? 'Added to Favourites!' : 'Removed from Favourites',
          style: const TextStyle(color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.surfaceBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _showEpisodes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildEpisodesBottomSheet(),
    );
  }

  void _shareVideo() {
    // TODO: Implement share functionality
    _showErrorSnackBar('Share functionality coming soon!');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    // Restore system UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _controlsAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () {
            if (_showControls) {
              _hideControls();
            } else {
              _showControlsOverlay();
            }
          },
          child: Stack(
            children: [
              // Video Player
              _buildVideoPlayer(),
              
              // All controls that appear/disappear together
              if (_showControls)
                AnimatedBuilder(
                  animation: _controlsOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controlsOpacity.value,
                      child: Stack(
                        children: [
                          // Top controls with gradient
                          _buildTopSection(),
                          
                          // Side action buttons
                          _buildSideActionButtons(),
                          
                          // Bottom info overlay
                          _buildBottomInfoOverlay(),
                          
                          // Progress bar
                          _buildProgressBarSection(),
                        ],
                      ),
                    );
                  },
                ),
              
              // Center play/pause button (appears/disappears)
              if (_showControls || !_isPlaying)
                AnimatedBuilder(
                  animation: _controlsOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _showControls ? _controlsOpacity.value : 1.0,
                      child: Center(
                        child: _buildCenterPlayButton(),
                      ),
                    );
                  },
                ),
              
              // Loading indicator
              if (_isBuffering)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized || _controller == null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.reel.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: AppTheme.primaryBackground.withValues(alpha: 0.3),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
            ),
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBackground.withValues(alpha: 0.7),
              AppTheme.primaryBackground.withValues(alpha: 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: _buildTopControls(),
        ),
      ),
    );
  }

  Widget _buildSideActionButtons() {
    return Positioned(
      right: 16,
      bottom: 200,
      child: Column(
        children: [
          // Like button
          _buildSideActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            label: '12.5K',
            onTap: _toggleLike,
            isActive: _isLiked,
          ),
          
          const SizedBox(height: 20),
          
          // Favourites button
          _buildSideActionButton(
            icon: _isInFavourites ? Icons.bookmark : Icons.bookmark_border,
            label: 'Save',
            onTap: _toggleFavourites,
            isActive: _isInFavourites,
          ),
          
          const SizedBox(height: 20),
          
          // Episodes button
          _buildSideActionButton(
            icon: Icons.playlist_play_rounded,
            label: 'Episodes',
            onTap: _showEpisodes,
          ),
          
          const SizedBox(height: 20),
          
          // Share button
          _buildSideActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            onTap: _shareVideo,
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.shottGold.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(color: AppTheme.shottGold, width: 2)
                    : Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isActive ? AppTheme.shottGold : Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.shottGold : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.primaryText,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          const Spacer(),
          
          // Video title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.reel.name,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const Spacer(),

          // More options
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppTheme.primaryText,
                size: 18,
              ),
              onPressed: () {
                // TODO: Show more options
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: AppTheme.shottGold,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shottGold.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.black,
          size: 42,
        ),
      ),
    );
  }

  Widget _buildProgressBarSection() {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SizedBox(
              height: 3,
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppTheme.shottGold,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white12,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInfoOverlay() {
    final String title = widget.episode?.name ?? widget.reel.name;
    final String description = widget.reel.description;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.95),
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.6),
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 100, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Episode/Reel title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: 0.2,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Episode details / Metadata row
                Row(
                  children: [
                    if (widget.episode != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.shottGold,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shottGold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'EP ${widget.episode!.episodeNumber}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    
                    const Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFFB0B0B0),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.episode?.duration ?? widget.reel.duration,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    
                    if (widget.episode == null) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB0B0B0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.reel.releaseDate,
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Description
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 13,
                      height: 1.5,
                      letterSpacing: 0.1,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.tertiaryText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          const Text(
            'More Episodes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          // Episodes list (placeholder)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.shottGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppTheme.shottGold,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Episode ${index + 1}',
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '${(index + 1) * 2} min',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Load selected episode
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
