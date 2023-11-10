import 'package:inner_breeze/models/session.dart';
import 'package:inner_breeze/models/preferences.dart';

class User {
  final String id;
  bool tutorialComplete;
  Preferences preferences;
  String? currentSessionId;
  List<Session> sessions;

  User({
    required this.id,
    this.tutorialComplete = false,
    required this.preferences,
    this.currentSessionId,
    this.sessions = const []
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutorialComplete': tutorialComplete,
      'preferences': preferences.toJson(),
      'currentSessionId': currentSessionId,
      'sessions': sessions.map((session) => session.toJson()).toList()
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      tutorialComplete: json['tutorialComplete'] ?? false,
      preferences: Preferences.fromJson(json['preferences'] ?? {}),
      currentSessionId: json['currentSessionId'],
      sessions: (json['sessions'] as List<dynamic>)
          .map((sessionJson) => Session.fromJson(sessionJson))
          .toList(),
    );
  }
}
