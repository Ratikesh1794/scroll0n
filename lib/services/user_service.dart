import 'package:shared_preferences/shared_preferences.dart';

/// User Service for managing user data in local storage
class UserService {
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  
  /// Save user's full name
  static Future<void> saveUserName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, fullName);
  }
  
  /// Get user's full name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }
  
  /// Get user's first name only
  static Future<String> getFirstName() async {
    final fullName = await getUserName();
    if (fullName == null || fullName.isEmpty) {
      return 'Guest'; // Default if no name is saved
    }
    // Extract first name (everything before first space)
    final firstName = fullName.trim().split(' ').first;
    return firstName;
  }
  
  /// Save user's phone number
  static Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPhone, phone);
  }
  
  /// Get user's phone number
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }
  
  /// Clear all user data (for logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhone);
  }
  
  /// Check if user has completed profile setup
  static Future<bool> isProfileComplete() async {
    final name = await getUserName();
    return name != null && name.isNotEmpty;
  }
}

