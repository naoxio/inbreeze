import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/utils/breathing_utils.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:inner_breeze/widgets/stop_session.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class ExerciseStep3 extends StatefulWidget {
  ExerciseStep3({super.key});

  @override
  State<ExerciseStep3> createState() => _ExerciseStep3State();
}

class _ExerciseStep3State extends State<ExerciseStep3> {
  String animationControl = 'forward';
  int volume = 80;
  int countdown = 30;
  int customTicker = 0;
  Duration tempoDuration = Duration(seconds: 2);
  String innerText= 'in';

  Timer? breathCycleTimer;

  @override
  void initState() {
    super.initState();
    _loadDataFromPreferences().then((_) {
      startBreathCounting();
    });
  }
  
  Future<void> _loadDataFromPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = await userProvider.loadUserPreferences(['volume']);

    setState(() {
      volume = preferences.volume;
    });
  }

  void _navigateToNextExercise() async{
    BreathingUtils.cancelBreathCycleTimer(breathCycleTimer);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }


  String getDisplayText() {
    switch (innerText) {
      case 'in':
        return 'in_breath'.i18n();
      case 'out':
        return 'out_breath'.i18n();
      default:
        return innerText;
    }
  }
   void startBreathCounting() {
    breathCycleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (animationControl == 'pause') return;  // Pause logic

      setState(() {
        customTicker++; 

        if (customTicker < 2) {
          innerText = 'in';
        } else if (customTicker < 17) {
          innerText = (17 - customTicker).toString();
          animationControl = 'stop';
        } else if (customTicker >= 17 && customTicker <= 18) {
          innerText = 'out';
          animationControl = 'reverse';
        } else {
          _navigateToNextExercise();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'recovery'.i18n(),
                  style: BreezeStyle.header,
                ),
                AnimatedCircle(
                  volume: volume,
                  tempoDuration: tempoDuration,
                  innerText: getDisplayText(),
                  controlCallback: () => animationControl,
                ),
                SizedBox(height: 200),
                StopSessionButton(
                  onPause: pauseBreathCounting,
                  onResume: resumeBreathCounting,
                ),
                TextButton(
                  child: Text('skip_button'.i18n()),
                  onPressed: () {
                    _navigateToNextExercise();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void pauseBreathCounting() {
    setState(() {
      animationControl = 'pause';
    });
  }

  void resumeBreathCounting() {
    setState(() {
      animationControl = 'resume';
    });
  }


  @override
  void dispose() {
    BreathingUtils.cancelBreathCycleTimer(breathCycleTimer);

    super.dispose();
  }
}