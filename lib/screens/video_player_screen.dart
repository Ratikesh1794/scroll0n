import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';

/// Professional Video Player Screen for Reels/Shorts (Instagram/YouTube Shorts Style)
/// 
/// Features:
/// - Portrait-only orientation optimized for short-form content
/// - Vertical scrolling between episodes (swipe up/down like TikTok, Instagram Reels)
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
  final List<Episode>? episodes;
  final List<Reel>? relatedReels;

  const VideoPlayerScreen({
    super.key,
    required this.reel,
    this.episode,
    this.episodes,
    this.relatedReels,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Video controllers for current, next, and previous videos
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;
  late PageController _pageController;
  
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
  
  // Episodes list
  late List<Episode> _episodes;
  
  @override
  void initState() {
    super.initState();
    
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize episodes list
    _episodes = widget.episodes ?? widget.reel.episodes;
    
    // Find the initial index if a specific episode is provided
    if (widget.episode != null) {
      _currentIndex = _episodes.indexWhere((e) => e.episodeNumber == widget.episode!.episodeNumber);
      if (_currentIndex == -1) _currentIndex = 0;
    }
    
    _pageController = PageController(initialPage: _currentIndex);
    _initializeAnimations();
    _initializeVideoPlayer(_currentIndex);
    _setupControlsTimer();
    
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Pause video when app goes to background
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      final controller = _controllers[_currentIndex];
      if (controller != null && controller.value.isPlaying) {
        controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
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

  Future<void> _initializeVideoPlayer(int index, {bool autoPlay = true}) async {
    if (_controllers.containsKey(index)) {
      // Controller already exists
      if (autoPlay && index == _currentIndex) {
        _controllers[index]!.play();
        setState(() {
          _isPlaying = true;
        });
      }
      return;
    }
    
    try {
      // For demo purposes, we'll use a placeholder video
      // In production, you'd use _episodes[index].videoUrl
      final controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      );

      await controller.initialize();
      
      if (mounted) {
        _controllers[index] = controller;
        
        // Set looping for seamless playback
        controller.setLooping(true);
        
        // Only auto-play if this is the current video and autoPlay is true
        if (autoPlay && index == _currentIndex) {
          controller.play();
          setState(() {
            _isPlaying = true;
          });
        }
        
        // Listen for video state changes
        controller.addListener(() => _videoListener(index));
      }
    } catch (e) {
      debugPrint('Error initializing video player at index $index: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to load video');
      }
    }
  }

  void _videoListener(int index) {
    if (!mounted || index != _currentIndex) return;
    
    final controller = _controllers[index];
    if (controller == null) return;
    
    final isBuffering = controller.value.isBuffering;
    final isPlaying = controller.value.isPlaying;
    
    if (_isBuffering != isBuffering || _isPlaying != isPlaying) {
      setState(() {
        _isBuffering = isBuffering;
        _isPlaying = isPlaying;
      });
    }
  }
  
  void _onPageChanged(int index) {
    // Pause ALL other videos to ensure nothing plays in background
    for (final entry in _controllers.entries) {
      if (entry.key != index && entry.value.value.isPlaying) {
        entry.value.pause();
      }
    }
    
    setState(() {
      _currentIndex = index;
      _showControls = true;
      _isPlaying = false; // Reset playing state
    });
    
    // Play new video
    _initializeVideoPlayer(index, autoPlay: true);
    
    // Preload next video (but don't play it)
    if (index + 1 < _episodes.length) {
      _initializeVideoPlayer(index + 1, autoPlay: false);
    }
    
    // Preload previous video (but don't play it)
    if (index > 0) {
      _initializeVideoPlayer(index - 1, autoPlay: false);
    }
    
    // Dispose old controllers to free memory (keep only current, prev, next)
    _disposeDistantControllers(index);
    
    _setupControlsTimer();
  }
  
  void _disposeDistantControllers(int currentIndex) {
    final controllersToDispose = <int>[];
    
    for (final index in _controllers.keys) {
      // Keep current, previous, and next controllers
      if ((index - currentIndex).abs() > 1) {
        controllersToDispose.add(index);
      }
    }
    
    for (final index in controllersToDispose) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
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
    final controller = _controllers[_currentIndex];
    if (controller != null && controller.value.isInitialized) {
      if (_isPlaying) {
        controller.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        controller.play();
        setState(() {
          _isPlaying = true;
        });
      }
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
      isScrollControlled: true,
      builder: (context) => _buildEpisodesBottomSheet(),
    );
  }
  
  void _jumpToEpisode(int episodeIndex) {
    Navigator.pop(context); // Close bottom sheet
    _pageController.animateToPage(
      episodeIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Restore system UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Pause and dispose all video controllers
    for (final controller in _controllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
      controller.dispose();
    }
    _controllers.clear();
    
    _pageController.dispose();
    _controlsAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _episodes.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return _buildVideoPage(index);
        },
      ),
    );
  }
  
  Widget _buildVideoPage(int index) {
    return FadeTransition(
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
            _buildVideoPlayer(index),
            
            // All controls that appear/disappear together
            if (_showControls && index == _currentIndex)
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
                        _buildProgressBarSection(index),
                      ],
                    ),
                  );
                },
              ),
            
            // Center play/pause button (appears/disappears)
            if (((_showControls && index == _currentIndex) || !_isPlaying) && index == _currentIndex)
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
            if (_isBuffering && index == _currentIndex)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.shottGold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    final controller = _controllers[index];
    
    if (controller == null || !controller.value.isInitialized) {
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
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
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
          
          // Video title with episode number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.reel.name} - EP ${_episodes[_currentIndex].episodeNumber}',
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

  Widget _buildProgressBarSection(int index) {
    final controller = _controllers[index];
    if (controller == null || !controller.value.isInitialized) {
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
                controller,
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
    final episode = _episodes[_currentIndex];
    final String title = episode.name;
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
                        'EP ${episode.episodeNumber}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    
                    const Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFFB0B0B0),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      episode.duration,
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
                    
                    const SizedBox(width: 12),
                    Text(
                      '${_currentIndex + 1}/${_episodes.length}',
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
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
          Text(
            'All Episodes (${_episodes.length})',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          // Episodes list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _episodes.length,
              itemBuilder: (context, index) {
                final episode = _episodes[index];
                final isCurrentEpisode = index == _currentIndex;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isCurrentEpisode 
                        ? AppTheme.shottGold.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrentEpisode
                        ? Border.all(color: AppTheme.shottGold, width: 1)
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrentEpisode
                              ? AppTheme.shottGold
                              : AppTheme.shottGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        isCurrentEpisode ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.shottGold,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      episode.name,
                      style: TextStyle(
                        color: AppTheme.primaryText,
                        fontWeight: isCurrentEpisode ? FontWeight.w700 : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'EP ${episode.episodeNumber} • ${episode.duration}',
                      style: TextStyle(
                        color: isCurrentEpisode 
                            ? AppTheme.shottGold
                            : AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    trailing: isCurrentEpisode
                        ? const Icon(
                            Icons.play_circle_filled,
                            color: AppTheme.shottGold,
                          )
                        : null,
                    onTap: () {
                      _jumpToEpisode(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
