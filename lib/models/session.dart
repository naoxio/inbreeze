class Session {
  final String id;
  Map<int, Duration> rounds;

  Session({required this.id, required this.rounds});

  Session copyWith({String? id, Map<int, Duration>? rounds}) {
    return Session(
      id: id ?? this.id,
      rounds: rounds ?? this.rounds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rounds': rounds
          .map((key, value) => MapEntry(key.toString(), value.inMilliseconds)),
    };
  }

  factory Session.fromJson(Map<String, dynamic> jsonData) {
    var roundsData = jsonData['rounds'] as Map<String, dynamic>? ?? {};
    Map<int, Duration> rounds = roundsData.map(
      (key, value) => MapEntry(int.parse(key), Duration(milliseconds: value)),
    );

    return Session(
      id: jsonData['id'] as String,
      rounds: rounds,
    );
  }

  DateTime get dateTime => DateTime.parse(id);

  int totalDurationInSeconds() {
    return rounds.values
        .fold(0, (int total, Duration d) => total + d.inSeconds);
  }
}
