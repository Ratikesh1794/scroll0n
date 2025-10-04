import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable Bottom Navigation Bar Component
/// 
/// Provides consistent navigation across all screens with
/// Home, Browse, Search, and Favourites options
class CustomBottomNavigationBar extends StatelessWidget {
  final int? currentIndex; // Made nullable to allow no selection
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    this.currentIndex, // Now optional
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 128), // 0.5 opacity
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              index: 0,
              label: 'Home',
            ),
            _buildNavItem(
              icon: Icons.explore_outlined,
              selectedIcon: Icons.explore,
              index: 1,
              label: 'Browse',
            ),
            _buildNavItem(
              icon: Icons.search_outlined,
              selectedIcon: Icons.search,
              index: 2,
              label: 'Search',
            ),
            _buildNavItem(
              icon: Icons.favorite_outline,
              selectedIcon: Icons.favorite,
              index: 3,
              label: 'Favourites',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required int index,
    required String label,
  }) {
    final bool isSelected = currentIndex != null && currentIndex == index;
    
    return IconButton(
      icon: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected ? Colors.white : Colors.white70,
        size: 28,
      ),
      padding: const EdgeInsets.all(8),
      onPressed: () => onTap(index),
      tooltip: label,
    );
  }
}