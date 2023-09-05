class Session {
  DateTime dateTime;
  Map<int, Duration> rounds;

  Session({required this.dateTime, required this.rounds});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['dateTime'] = dateTime.toIso8601String();
    data['rounds'] = rounds.map((key, value) => MapEntry(key.toString(), value.inMilliseconds));
    return data;
  }

  factory Session.fromJson(Map<String, dynamic> jsonData) {
    Map<int, Duration> rounds = {};
    Map<String, dynamic> roundsData = jsonData['rounds'] ?? {};
    roundsData.forEach((key, value) {
      rounds[int.parse(key)] = Duration(milliseconds: value);
    });
    return Session(dateTime: DateTime.parse(jsonData['dateTime']), rounds: rounds);
  }
}
