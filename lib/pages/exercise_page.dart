
import 'package:flutter/material.dart';
import 'exercise/step1.dart';

class ExercisePage extends StatelessWidget {
  // Constructs a [TutorialPage]
  const ExercisePage({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case '':
        pageToDisplay = Step1Page();
        break;
      case 'step1':
        pageToDisplay = Step1Page();
        break;
      default:
        pageToDisplay = Step1Page();
    }
    return pageToDisplay;
  }
}

