import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionManager {
  static final SessionManager instance = SessionManager._();
  SessionManager._();

  static const String _userKey = "userId";
  

  String? _sessionId;
  String? _userId;
  String? _cachedUserId;
  String? _gameId;

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
      _cachedUserId = saved;
      return saved;
    }

    final newId = const Uuid().v4();
    await prefs.setString(_userKey, newId);
    _userId = newId;
    _cachedUserId = newId;

    return newId;
  }

  /// Placeholder gameId getter, acts like session ID
  Future<String> get gameId async {
    _gameId ??= const Uuid().v4();
    return _gameId!;
  }

  void set gameId(String value) {
    _gameId = value;
  }

  String? get currentUserId => _cachedUserId;
}
