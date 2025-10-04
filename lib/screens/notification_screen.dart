import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'browse_screen.dart';
import 'search_screen.dart';
import 'favourites_screen.dart';
import 'profile_screen.dart';

/// Notification Screen
/// 
/// Displays user notifications including new releases, updates, and promotions
/// Follows the app's design system with gradient background
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock notification data - replace with actual data source later
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'New Release',
      message: 'Pushpa 2: The Rule is now available to watch!',
      time: '2 hours ago',
      isRead: false,
      type: NotificationType.newRelease,
    ),
    NotificationItem(
      title: 'Coming Soon',
      message: 'Devara: Part 1 premieres tomorrow. Don\'t miss it!',
      time: '5 hours ago',
      isRead: false,
      type: NotificationType.comingSoon,
    ),
    NotificationItem(
      title: 'Recommendation',
      message: 'Based on your viewing history, you might like "Salaar"',
      time: '1 day ago',
      isRead: true,
      type: NotificationType.recommendation,
    ),
    NotificationItem(
      title: 'Update',
      message: 'New episodes added to your favorite series!',
      time: '2 days ago',
      isRead: true,
      type: NotificationType.update,
    ),
    NotificationItem(
      title: 'Promo',
      message: 'Premium subscription - Get 30% off this weekend only!',
      time: '3 days ago',
      isRead: true,
      type: NotificationType.promo,
    ),
  ];

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        // Navigate to Browse
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BrowseScreen()),
        );
        break;
      case 2:
        // Navigate to Search
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 3:
        // Navigate to Favourites
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
        );
        break;
    }
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: null, // No selection - notifications is independent
        onTap: _handleNavigation,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A2C32), // Very dark teal matching home screen
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white70,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    // Title
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    // Profile icon
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Mark all as read button
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _markAllAsRead,
                        icon: const Icon(
                          Icons.done_all,
                          size: 18,
                          color: AppTheme.accent,
                        ),
                        label: Text(
                          'Mark all as read',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Notifications list
              Expanded(
                child: _notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return _buildNotificationCard(notification, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something new arrives',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return GestureDetector(
      onTap: () => _markAsRead(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.black.withValues(alpha: 0.2 * 255)
              : AppTheme.primary.withValues(alpha: 0.15 * 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : AppTheme.primary.withValues(alpha: 0.3 * 255),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.2 * 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.shottGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newRelease:
        return Icons.fiber_new;
      case NotificationType.comingSoon:
        return Icons.schedule;
      case NotificationType.recommendation:
        return Icons.thumb_up_outlined;
      case NotificationType.update:
        return Icons.system_update;
      case NotificationType.promo:
        return Icons.local_offer;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.newRelease:
        return AppTheme.shottGold;
      case NotificationType.comingSoon:
        return AppTheme.accent;
      case NotificationType.recommendation:
        return Colors.blue;
      case NotificationType.update:
        return Colors.green;
      case NotificationType.promo:
        return Colors.purple;
    }
  }
}

// Notification data model
class NotificationItem {
  final String title;
  final String message;
  final String time;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });
}

enum NotificationType {
  newRelease,
  comingSoon,
  recommendation,
  update,
  promo,
}

