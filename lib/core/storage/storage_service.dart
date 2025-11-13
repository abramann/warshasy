// lib/core/storage/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for handling local storage using SharedPreferences
/// Provides type-safe methods for storing and retrieving data
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // ============================================
  // STRING OPERATIONS
  // ============================================

  /// Save a string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  /// Get a string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // INT OPERATIONS
  // ============================================

  /// Save an integer value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      return false;
    }
  }

  /// Get an integer value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // DOUBLE OPERATIONS
  // ============================================

  /// Save a double value
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      return false;
    }
  }

  /// Get a double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // BOOL OPERATIONS
  // ============================================

  /// Save a boolean value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      return false;
    }
  }

  /// Get a boolean value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // LIST OPERATIONS
  // ============================================

  /// Save a list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      return false;
    }
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // JSON/OBJECT OPERATIONS
  // ============================================

  /// Save a JSON object (as string)
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    try {
      final jsonString = jsonEncode(json);
      return await _prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Get a JSON object (from string)
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Save a list of JSON objects
  Future<bool> saveJsonList(
    String key,
    List<Map<String, dynamic>> jsonList,
  ) async {
    try {
      final jsonString = jsonEncode(jsonList);
      return await _prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Get a list of JSON objects
  List<Map<String, dynamic>>? getJsonList(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // DELETE OPERATIONS
  // ============================================

  /// Remove a specific key
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      return false;
    }
  }

  /// Remove multiple keys
  Future<bool> removeMultiple(List<String> keys) async {
    try {
      for (final key in keys) {
        await _prefs.remove(key);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      return false;
    }
  }

  // ============================================
  // UTILITY OPERATIONS
  // ============================================

  /// Check if a key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  /// Reload preferences from storage
  Future<void> reload() async {
    await _prefs.reload();
  }

  // ============================================
  // TYPE-SAFE GETTERS WITH DEFAULTS
  // ============================================

  /// Get string with default value
  String getStringOrDefault(String key, String defaultValue) {
    return _prefs.getString(key) ?? defaultValue;
  }

  /// Get int with default value
  int getIntOrDefault(String key, int defaultValue) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  /// Get double with default value
  double getDoubleOrDefault(String key, double defaultValue) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  /// Get bool with default value
  bool getBoolOrDefault(String key, bool defaultValue) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  /// Get string list with default value
  List<String> getStringListOrDefault(String key, List<String> defaultValue) {
    return _prefs.getStringList(key) ?? defaultValue;
  }
}
