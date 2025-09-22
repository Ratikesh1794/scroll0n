import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category.dart';

class ReelService {
  static Future<ReelData> loadReelData() async {
    try {
      final String jsonString = await rootBundle.loadString('data/dummydata/reellist.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return ReelData.fromJson(jsonData);
    } catch (e) {
      // Return empty data if loading fails
      return ReelData(categories: []);
    }
  }
}
