import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:provider/provider.dart';

class GuideStep1Screen extends StatefulWidget {
  @override
  State<GuideStep1Screen> createState() => _GuideStep1ScreenState();
}

enum BreathingTempo {slow, medium, fast, rapid}

class _GuideStep1ScreenState extends State<GuideStep1Screen> {
  int breaths = 30;
  int volume = 90;
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
      tempoDuration = Duration(milliseconds: prefs['tempo'] ?? 1668);
      breaths = prefs['breaths'] ?? 30;
      volume = prefs['volume'] ?? 90;
    });
  }
  
  Duration computeTempoDuration(double value) {
    // This will map the range [0,3] to [3000ms, 1000ms] respectively
    int millis = (3000 - value * 666).toInt().clamp(1000, 3000);
    return Duration(milliseconds: millis);
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue = 3 - (tempoDuration.inMilliseconds - 1000) / 666;

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
            style: BreezeStyle.header
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
            child: AnimatedCircle(
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
    setState(() {
      tempoDuration = computeTempoDuration(newTempo);
      animationCommand = 'reset';
    });
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.saveUserPreferences({
      'tempo': tempoDuration.inMilliseconds,
      'breaths': breaths,
      'volume': volume,
    });
  }

  void _updateVolume(double newVolume) {
    setState(() {
      volume = newVolume.toInt();
      animationCommand = 'repeat';
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.saveUserPreferences({
      'tempo': tempoDuration.inMilliseconds,
      'breaths': breaths,
      'volume': volume,
    });
  }

  void _updateBreaths(double newBreaths) {
    setState(() {
      breaths = newBreaths.toInt();
      animationCommand = 'repeat';
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.saveUserPreferences({
      'tempo': tempoDuration.inMilliseconds,
      'breaths': breaths,
      'volume': volume,
    });
  }
  String capitalizeEnumValue(String enumValue) {

    return enumValue[0].toUpperCase() + enumValue.substring(1, enumValue.length );
  }
}