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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing based on screen height
    final navBarHeight = screenHeight * 0.09; // 9% of screen height
    final iconSize = screenWidth * 0.065; // 6.5% of screen width
    final fontSize = screenWidth * 0.028; // 2.8% of screen width
    final verticalPadding = screenHeight * 0.006; // 0.6% of screen height
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 128), // 0.5 opacity
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 65.0,
            maxHeight: navBarHeight.clamp(70.0, 85.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: verticalPadding.clamp(2.0, 8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                index: 0,
                label: 'Home',
                iconSize: iconSize.clamp(24.0, 32.0),
                fontSize: fontSize.clamp(10.0, 13.0),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                index: 1,
                label: 'Browse',
                iconSize: iconSize.clamp(24.0, 32.0),
                fontSize: fontSize.clamp(10.0, 13.0),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.search_outlined,
                selectedIcon: Icons.search,
                index: 2,
                label: 'Search',
                iconSize: iconSize.clamp(24.0, 32.0),
                fontSize: fontSize.clamp(10.0, 13.0),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.favorite_outline,
                selectedIcon: Icons.favorite,
                index: 3,
                label: 'Favourites',
                iconSize: iconSize.clamp(24.0, 32.0),
                fontSize: fontSize.clamp(10.0, 13.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required int index,
    required String label,
    required double iconSize,
    required double fontSize,
  }) {
    final bool isSelected = currentIndex != null && currentIndex == index;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: (screenHeight * 0.004).clamp(2.0, 6.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: iconSize,
              ),
              SizedBox(height: (screenHeight * 0.002).clamp(2.0, 4.0)),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}