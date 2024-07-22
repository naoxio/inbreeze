import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/preferences.dart';

class BreathingConfiguration extends StatefulWidget {
  @override
  BreathingConfigurationState createState() => BreathingConfigurationState();
}

class BreathingConfigurationState extends State<BreathingConfiguration> {
  int breaths = 30;
  int volume = 100;
  double secondsPerBreath = 1.668; // Default tempo in seconds
  String animationCommand = 'repeat';

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final prefs = await userProvider.loadUserPreferences(['breaths', 'tempo', 'volume']);

    setState(() {
      secondsPerBreath = prefs.tempo / 1000; // Convert milliseconds to seconds
      breaths = prefs.breaths;
      volume = prefs.volume;
    });
  }

  void _updateUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = Preferences(
      tempo: (secondsPerBreath * 1000).round(), // Convert seconds to milliseconds
      breaths: breaths,
      volume: volume,
    );
    userProvider.saveUserPreferences(preferences);
  }

  void _updateTempo(double newTempo) {
    setState(() {
      secondsPerBreath = newTempo;
      animationCommand = 'reset';
    });
    _updateUser();
  }

  void _updateVolume(double newVolume) {
    setState(() {
      volume = newVolume.toInt();
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  void _updateBreaths(double newBreaths) {
    setState(() {
      breaths = newBreaths.toInt();
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  String _getTempoLabel(double seconds) {
    if (seconds < 1) return 'Very Fast';
    if (seconds < 1.5) return 'Fast';
    if (seconds < 2) return 'Medium';
    return 'Slow';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 90),
        Center(
          child: AnimatedCircle(
            tempoDuration: Duration(milliseconds: (secondsPerBreath * 1000).round()),
            volume: volume,
            controlCallback: () {
              return animationCommand;
            },
          ),
        ),
        SizedBox(height: 90),
        Text(
          'Breathing Tempo (Seconds per Breath)',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 0.5,
          max: 3.0,
          divisions: 25, // This gives steps of 0.1 seconds
          value: secondsPerBreath,
          label: '${secondsPerBreath.toStringAsFixed(1)}s (${_getTempoLabel(secondsPerBreath)})',
          onChanged: (value) {
            _updateTempo(value);
          },
        ),
        SizedBox(height: 10),
        Text(
          'volume_label'.i18n(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 0.0,
          max: 100.0,
          label: '${volume.round()}%',
          divisions: 10,
          value: volume.toDouble(),
          onChanged: (dynamic value) {
            _updateVolume(value);
          },
        ),
        SizedBox(height: 10),
        Text(
          'breaths_label'.i18n(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 20.0,
          max: 40.0,
          label: '${breaths.round()}',
          divisions: 4,
          value: breaths.toDouble(),
          onChanged: (dynamic value) {
            _updateBreaths(value);
          },
        ),
      ],
    );
  }
}