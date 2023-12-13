import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/preferences.dart';

enum BreathingTempo {slow, medium, fast, rapid}

class BreathingConfiguration extends StatefulWidget {
  @override
  BreathingConfigurationState createState() => BreathingConfigurationState();
}

class BreathingConfigurationState extends State<BreathingConfiguration> {
  int breaths = 30;
  int volume = 100;
  Duration tempoDuration = Duration(milliseconds: 1668); 
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
      tempoDuration = Duration(milliseconds: prefs.tempo);
      breaths = prefs.breaths;
      volume = prefs.volume;
    });
  }
  Duration computeTempoDuration(double value) {
    int millis = (3000 - value * 666).toInt().clamp(1000, 3000);
    return Duration(milliseconds: millis);
  }

  void _updateUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = Preferences(
      tempo: tempoDuration.inMilliseconds,
      breaths: breaths,
      volume: volume,
    );
    userProvider.saveUserPreferences(preferences);
  }

  void _updateTempo(double newTempo) {
    setState(() {
      tempoDuration = computeTempoDuration(newTempo);
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

  String capitalizeEnumValue(String enumValue) {
    return enumValue[0].toUpperCase() + enumValue.substring(1, enumValue.length);
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue = 3 - (tempoDuration.inMilliseconds - 1000) / 666;

    return Column(
      children: [
        Center(
          child: AnimatedCircle(
            key: UniqueKey(),
            tempoDuration: tempoDuration,
            volume: volume,
            controlCallback: () {
              return animationCommand;
            },
          ),
        ),
        SizedBox(height: 190),
        Text(
          'Tempo',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 0,
          max: 3,
          label: capitalizeEnumValue(BreathingTempo.values[sliderValue.round()].name),
          divisions: 3,
          value: sliderValue.clamp(0.0, 3.0),
          onChanged: (dynamic value) {
            _updateTempo(value);
          },
        ),
        SizedBox(height: 10),
        Text(
          'Volume',
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
          'Breaths',
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
