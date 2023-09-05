import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _sessionId;
  Map<int, Duration> roundDurations = {};

  UserProvider() {
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    if (_userId == null) {
      _userId = Uuid().v4();
      prefs.setString('userId', _userId!);
    }
  }

  String? get userId => _userId;
  String? get sessionId => _sessionId;

  Future<void> markTutorialAsComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('$_userId/tutorialComplete', true);
  }

  Future<bool> hasValidSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sessionId = prefs.getString('$_userId/currentSession');
    return sessionId != null;
  }

  Future<Map<String, dynamic>> _loadData(List<String> keys, String prefix) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> loadedData = {};
    for (var key in keys) {
      dynamic value = prefs.get('$prefix/$key');
      if (value != null) {
        loadedData[key] = value;
      }
    }
    return loadedData;
  }

  Future<void> _saveData(Map<String, dynamic> data, String prefix) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in data.keys) {
      var value = data[key];
      if (value is int) {
        prefs.setInt('$prefix/$key', value);
      } else if (value is String) {
        prefs.setString('$prefix/$key', value);
      } else if (value is bool) {
        prefs.setBool('$prefix/$key', value);
      }
    }
  }

  Future<Map<String, dynamic>> loadUserPreferences(List<String> keys) async {
    return await _loadData(keys, '$_userId');
  }

  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await _saveData(preferences, '$_userId');
  }

  Future<Map<String, dynamic>> loadSessionData(List<String> keys) async {
    return await _loadData(keys, '$_userId/sessions/$_sessionId');
  }

  Future<void> saveSessionData(Map<String, dynamic> data) async {
    await _saveData(data, '$_userId/sessions/$_sessionId');
  }

  Future<void> saveRoundDuration(int roundNumber, Duration duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = '$_userId/sessions/$_sessionId/$roundNumber';
    prefs.setInt(key, duration.inMilliseconds);
  }


  Future<String?> startNewSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _sessionId = Uuid().v4();
    prefs.setInt('$_userId/sessions/$_sessionId/rounds', 0);
    prefs.setString('$_userId/currentSession', _sessionId!);
    return _sessionId;
  }

  Future<Map<int, Duration>> loadRoundDurations() async {
    Map<String, dynamic> sessionData = await loadSessionData(['rounds']);
    int rounds = sessionData['rounds'] ?? 0;

    Map<int, Duration> roundDurations = {};
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    for (int i = 1; i <= rounds; i++) {
      final key = '$_userId/sessions/$_sessionId/$i';
      int? durationInMillis = prefs.getInt(key);
      if (durationInMillis != null) {
        roundDurations[i] = Duration(milliseconds: durationInMillis);
      }
    }

    return roundDurations;
  }


  Future<void> clearCurrentSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$_userId/currentSession');
  }

  Future<void> deleteSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    Set<String> allKeys = prefs.getKeys();

    Iterable<String> sessionKeys = allKeys.where((key) => key.startsWith('$_userId/sessions/$_sessionId/'));

    for (String key in sessionKeys) {
      prefs.remove(key);
    }
  }

  Future<void> deleteRound(int roundNumber) async {
    Map<String, dynamic> sessionData = await loadSessionData(['rounds']);
    int rounds = sessionData['rounds'] ?? 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = '$_userId/sessions/$_sessionId/$roundNumber';
    prefs.remove(key);

    for (int i = roundNumber + 1; i <= rounds; i++) {
        final oldKey = '$_userId/sessions/$_sessionId/$i';
        final newKey = '$_userId/sessions/$_sessionId/${i - 1}';

        final durationInMillis = prefs.getInt(oldKey);
        if (durationInMillis != null) {
            prefs.setInt(newKey, durationInMillis);
            prefs.remove(oldKey);
        }
    }

    rounds -= 1;
    prefs.setInt('$_userId/sessions/$_sessionId/rounds', rounds);

    roundDurations.remove(roundNumber);
    for (int i = roundNumber + 1; i <= rounds + 1; i++) {
        roundDurations[i - 1] = roundDurations.remove(i) ?? Duration();
    }

    notifyListeners();
  }

}