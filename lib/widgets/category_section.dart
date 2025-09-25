import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import 'reel_card.dart';

class CategorySection extends StatelessWidget {
  final Category category;
  final Function(String reelId)? onReelTap;

  const CategorySection({
    super.key,
    required this.category,
    this.onReelTap,
  });

  @override
  Widget build(BuildContext context) {
    if (category.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: AppTheme.sectionHeader.copyWith(
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to category page with all items
                },
                child: Text(
                  'See All',
                  style: AppTheme.premiumText.copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Horizontal scrollable list of reel cards
        SizedBox(
          height: 280, // Height to accommodate card + title + date
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: category.items.length,
            itemBuilder: (context, index) {
              final reel = category.items[index];
              return ReelCard(
                reel: reel,
                onTap: () {
                  onReelTap?.call(reel.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
