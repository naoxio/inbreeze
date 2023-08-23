
import 'package:flutter/material.dart';
import '../screens/exercise/exercise_step1.dart';
import '../screens/exercise/exercise_step2.dart';
import '../screens/exercise/exercise_step3.dart';

class ExerciseRouter extends StatelessWidget {
  // Constructs a [TutorialPage]
  const ExerciseRouter({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case '':
        pageToDisplay = ExerciseStep1();
        break;
      case 'step1':
        pageToDisplay = ExerciseStep1();
        break;
      case 'step2':
        pageToDisplay = ExerciseStep2();
        break;
      case 'step3':
        pageToDisplay = ExerciseStep3();
        break;
      default:
        pageToDisplay = ExerciseStep1();
    }
    return pageToDisplay;
  }
}

