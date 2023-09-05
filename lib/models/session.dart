class Session {
  String id;  // <-- New id property
  DateTime dateTime;
  Map<int, Duration> rounds;

  Session({required this.id, required this.dateTime, required this.rounds});  // <-- Updated constructor to accept id

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;  // <-- Include id in JSON
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
    return Session(
      id: jsonData['id'],  // <-- Extract id from JSON
      dateTime: DateTime.parse(jsonData['dateTime']), 
      rounds: rounds
    );
  }
}
