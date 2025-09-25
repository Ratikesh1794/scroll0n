import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/reel.dart';
import '../theme/app_theme.dart';

/// Professional Video Player Screen for Reels/Shorts
/// 
/// Features:
/// - Portrait-only orientation for optimal short video experience
/// - Disappearing overlay with OTT-specific controls
/// - Professional streaming platform design
/// - Smooth animations and transitions
/// - Full-screen immersive experience
class VideoPlayerScreen extends StatefulWidget {
  final Reel reel;
  final List<Reel>? relatedReels;

  const VideoPlayerScreen({
    super.key,
    required this.reel,
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
  bool _isSubscribed = false;
  
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

  void _toggleSubscribe() {
    setState(() {
      _isSubscribed = !_isSubscribed;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSubscribed ? 'Subscribed successfully!' : 'Unsubscribed',
          style: const TextStyle(color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.surfaceBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
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
              
              // Controls Overlay
              if (_showControls)
                AnimatedBuilder(
                  animation: _controlsOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controlsOpacity.value,
                      child: _buildControlsOverlay(),
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

  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryBackground.withValues(alpha: 0.7),
            Colors.transparent,
            Colors.transparent,
            AppTheme.primaryBackground.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top controls
            _buildTopControls(),
            
            // Center play/pause
            Expanded(
              child: Center(
                child: _buildCenterPlayButton(),
              ),
            ),
            
            // Bottom controls
            _buildBottomControls(),
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
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.shottGold.withValues(alpha: 0.3),
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
          
          const Spacer(),
          
          // Video title
          Expanded(
            flex: 3,
            child: Text(
              widget.reel.name,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const Spacer(),
          
          // More options
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.shottGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppTheme.primaryText,
                size: 20,
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
    if (_isPlaying) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: _togglePlayPause,
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
        child: const Icon(
          Icons.play_arrow_rounded,
          color: AppTheme.primaryBackground,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar
          if (_isInitialized && _controller != null)
            _buildProgressBar(),
          
          const SizedBox(height: 20),
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return VideoProgressIndicator(
      _controller!,
      allowScrubbing: true,
      colors: const VideoProgressColors(
        playedColor: AppTheme.shottGold,
        bufferedColor: Colors.white24,
        backgroundColor: Colors.white12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Subscribe button
        _buildActionButton(
          icon: _isSubscribed ? Icons.notifications : Icons.notifications_none,
          label: _isSubscribed ? 'Subscribed' : 'Subscribe',
          onTap: _toggleSubscribe,
          isActive: _isSubscribed,
        ),
        
        // Episodes button
        _buildActionButton(
          icon: Icons.playlist_play_rounded,
          label: 'Episodes',
          onTap: _showEpisodes,
        ),
        
        // Share button
        _buildActionButton(
          icon: Icons.share_rounded,
          label: 'Share',
          onTap: _shareVideo,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
              ? AppTheme.shottGold.withValues(alpha: 0.2)
              : AppTheme.surfaceBackground.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive 
                ? AppTheme.shottGold
                : AppTheme.shottGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.shottGold : AppTheme.primaryText,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.shottGold : AppTheme.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
