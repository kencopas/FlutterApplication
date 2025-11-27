import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionManager {
  static final SessionManager instance = SessionManager._();
  SessionManager._();

  static const String _userKey = "userId";
  static const String _userDataKey = "userData";

  String? _sessionId;
  String? _userId;
  Map<String, dynamic>? _userData;

  /// Creates a new session ID if none in memory; Returns `_sessionId`
  Future<String> get sessionId async {
    // Always generate a new one each app launch.
    _sessionId ??= const Uuid().v4();
    return _sessionId!;
  }

  /// Checks for `_userId` in memory, then persistent storage, else creates new; Returns `_userId`
  Future<String> get userId async {
    if (_userId != null) return _userId!;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_userKey);

    if (saved != null) {
      _userId = saved;
      return saved;
    }

    final newId = const Uuid().v4();
    await prefs.setString(_userKey, newId);
    _userId = newId;

    return newId;
  }

  /// Checks for `_userData` in memory, then persistent storage; Returns `_userData` or empty map
  Future<Map<String, dynamic>> get userData async {
    if (_userData != null) return _userData!;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userDataKey);

    if (raw != null) {
      _userData = jsonDecode(raw);
      return _userData!;
    }

    return {};
  }

  /// Saves user data to persistent storage and updates in-memory cache
  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(data));
    _userData = data;
    print("User data saved: $data");
  }

  /// Clears the in-memory session ID (`_sessionId`)
  void clearSessionId() {
    _sessionId = null;
  }
}
