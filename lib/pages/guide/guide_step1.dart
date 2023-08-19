import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';
import '../../components/animated_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuideStep1Page extends StatefulWidget {
  @override
  State<GuideStep1Page> createState() => _GuideStep1PageState();
}

enum BreathingTempo {slow, medium, fast, rapid}

class _GuideStep1PageState extends State<GuideStep1Page> {
  int tempo = 1;
  int breaths = 30;
  int volume = 90;
  Duration tempoDuration = Duration(seconds: 1);
  String animationCommand = 'repeat';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tempo = prefs.getInt('tempo') ?? 1;
      breaths = prefs.getInt('breaths') ?? 30;
      volume = prefs.getInt('volume') ?? 90;
    });
  }
  
  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('tempo', tempo);
    prefs.setInt('breaths', breaths);
    prefs.setInt('volume', volume);
  }

  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      backButtonText: 'Back',
      backButtonPressed: () {
        context.go('/guide/method');
      },
      forwardButtonText: 'Continue',
      forwardButtonPressed: () {
        context.go('/guide/step2');
      },
      column: Column(
        children: [
          Text(
            'Step 1: In & Out',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text('''
Fill your lungs with a full breath, starting from your belly, then your chest.

Allow the breath to flow out naturally without strain.

Repeat this for about 20-40 breaths at a steady pace.''',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Breathing Circle',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: AnimatedBreathingCircle(
              tempoDuration: tempoDuration, 
              volume: volume,
              controlCallback: () {
                return animationCommand;
              }
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
            label: capitalizeEnumValue(BreathingTempo.values[tempo].name),
            divisions: 3,
            value: tempo.toDouble(),
            onChanged: (dynamic value){
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
            onChanged: (dynamic value){
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
            onChanged: (dynamic value){
              _updateBreaths(value);
            },
          ),
        ],
      ),
    );
  }

  void _updateTempo(double newTempo) {
    print('udpating tempo');
    setState(() {
      tempo = newTempo.toInt();

      tempoDuration = Duration(milliseconds: 2860 - (tempo* 542).toInt()) * 2;

      animationCommand = 'reset';

    });
    _savePreferences();
  }

  void _updateVolume(double newVolume) {
    setState(() {
      volume = newVolume.toInt();
    });
    _savePreferences();
  }

  void _updateBreaths(double newBreaths) {
    setState(() {
      breaths = newBreaths.toInt();
    });
    _savePreferences();
  }

  String capitalizeEnumValue(String enumValue) {

    return enumValue[0].toUpperCase() + enumValue.substring(1, enumValue.length );
  }
}