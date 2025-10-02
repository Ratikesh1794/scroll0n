import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/category.dart';
import '../models/reel.dart';

class ReelService {
  static Future<ReelData> loadReelData() async {
    try {
      final String jsonString = await rootBundle.loadString('data/dummydata/reellist.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return ReelData.fromJson(jsonData);
    } catch (e) {
      // Return empty data if loading fails
      debugPrint('Error loading reellist.json: $e');
      return ReelData(categories: []);
    }
  }

  static Future<List<Reel>> loadFeaturedReels() async {
    try {
      final String jsonString = await rootBundle.loadString('data/dummydata/featured.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> categories = jsonData['categories'] ?? [];
      final List<Reel> featuredReels = [];
      
      // Get first reel from each category for featured section
      for (final category in categories) {
        final List<dynamic> items = category['items'] ?? [];
        if (items.isNotEmpty) {
          featuredReels.add(Reel.fromJson(items.first));
        }
      }
      
      return featuredReels;
    } catch (e) {
      // Return empty list if loading fails
      debugPrint('Error loading featured.json: $e');
      return [];
    }
  }
}
