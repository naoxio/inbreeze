import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:inner_breeze/models/preferences.dart';
import 'package:inner_breeze/models/user.dart';

class UserProvider with ChangeNotifier {
  User user = User(id: '', preferences: Preferences(), sessions: []);
  Map<int, Duration> roundDurations = {};

  UserProvider() {
    _initializeUser();
  }

Future<void> _initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      final newUser = User(
        id: Uuid().v4(),
        preferences: Preferences(),
      );
      user = newUser;
      await _saveUser();
    } else {
      final userJson = prefs.getString(userId);
      if (userJson != null) {
        user = User.fromJson(jsonDecode(userJson));
      } else {
        final newUser = User(
          id: userId,
          preferences: Preferences(),
        );
        user = newUser;
        await _saveUser();
      }
    }
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(user.id, jsonEncode(user.toJson()));
  }

  Future<void> markTutorialAsComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('${user.id}/tutorialComplete', true);
  }

  Future<bool> hasValidSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sessionId = prefs.getString('${user.id}/currentSession');
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

  Future<Preferences> loadUserPreferences(List<String> keys) async {
    Map<String, dynamic> data = await _loadData(keys, user.id);
    return Preferences.fromJson(data);
  }

  Future<void> saveUserPreferences(Preferences preferences) async {
    await _saveData(preferences.toJson(), user.id);
  }

  Future<Session?> loadSessionData(List<String> keys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionJson = prefs.getString('${user.id}/sessions/${user.currentSessionId}');
    if (sessionJson == null) return null;

    return Session.fromJson(jsonDecode(sessionJson));  
  }

  Future<void> saveSessionData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionJson = prefs.getString('${user.id}/sessions/${user.currentSessionId}');
    if (sessionJson == null) return;

    Session session = Session.fromJson(jsonDecode(sessionJson));
    
    if (data.containsKey('dateTime')) {
      session.dateTime = DateTime.parse(data['dateTime']);
    }
    if (data.containsKey('rounds')) {
      Map<int, Duration> roundsData = data['rounds'];
      roundsData.forEach((key, value) {
        session.rounds[key] = value;
      });
    }

    String updatedSessionJson = jsonEncode(session.toJson());
    prefs.setString('${user.id}/sessions/${user.currentSessionId}', updatedSessionJson);
  }

  Future<String?> startNewSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user.currentSessionId = Uuid().v4();
    Session session = Session(dateTime: DateTime.now(), rounds: {});
    String sessionJson = jsonEncode(session.toJson());
    prefs.setString('${user.id}/sessions/${user.currentSessionId}', sessionJson);

    return user.currentSessionId;
  }

  Future<Map<int, Duration>> loadRoundDurations() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('${user.id}/sessions/${user.currentSessionId}');
    if (sessionJson == null) return {};

    final sessionData = Session.fromJson(jsonDecode(sessionJson));

    return sessionData.rounds;
  }

  Future<void> clearCurrentSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('${user.id}/currentSession');
  }

  Future<void> deleteSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    Set<String> allKeys = prefs.getKeys();

    Iterable<String> sessionKeys = allKeys.where((key) => key.startsWith('${user.id}/sessions/${user.currentSessionId}/'));

    for (String key in sessionKeys) {
      prefs.remove(key);
    }
  }

  Future<void> deleteRound(int roundNumber) async {
    final prefs = await SharedPreferences.getInstance();
    Session? sessionData = await loadSessionData(['rounds']);
    if (sessionData == null) return;

    sessionData.rounds.remove(roundNumber);

    String updatedSessionJson = jsonEncode(sessionData.toJson());
    prefs.setString('${user.id}/sessions/${user.currentSessionId}', updatedSessionJson);

  }

  Future<List<Session>> getAllSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    List<Session> sessions = [];

    for (String key in allKeys) {
      if (key.startsWith('${user.id}/sessions/')) {
        print('beoreoeeoreoreo');
        var sessionData = jsonDecode(prefs.get(key)!.toString());
        //Map<String, dynamic> sessionData = jsonDecode(prefs.get(key)!.toString());
        print('errororrororo');
        if (sessionData is Map<String, dynamic> && sessionData.containsKey('dateTime') && sessionData['rounds'].length > 0) {
          sessions.add(Session.fromJson(sessionData));
        }
      }
    }

    sessions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return sessions;
  }

}