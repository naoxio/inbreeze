class Preferences {
  bool notificationEnabled;
  String theme;
  int tempo;
  int breaths;
  int volume;

  Preferences({
    this.notificationEnabled = true,
    this.theme = 'dark',
    this.tempo = 1668,
    this.breaths = 30,
    this.volume = 90, 
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationEnabled': notificationEnabled,
      'theme': theme,
      'tempo': tempo,
      'breaths': breaths,
      'volume': volume,
    };
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notificationEnabled: json['notificationEnabled'] ?? true,
      theme: json['theme'] ?? 'dark',
      tempo: json['tempo'] ?? 1668,
      breaths: json['breaths'] ?? 30,
      volume: json['volume'] ?? 90,
    );
  }
}
