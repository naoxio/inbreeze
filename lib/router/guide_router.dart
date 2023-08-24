
import 'package:flutter/material.dart';
import '../screens/guide/guide_welcome_screen.dart';
import '../screens/guide/guide_method_screen.dart';
import '../screens/guide/guide_step1.dart';
import '../screens/guide/guide_step2.dart';
import '../screens/guide/guide_step3.dart';

class GuideRouter extends StatelessWidget {
  // Constructs a [TutorialPage]
  const GuideRouter({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case '':
        pageToDisplay = GuideWelcomeScreen();
        break;
      case 'method':
        pageToDisplay = GuideMethodScreen();
        break;
      case 'step1':
        pageToDisplay = GuideStep1Screen();
        break;
      case 'step2':
        pageToDisplay = GuideStep2Screen();
        break;
      case 'step3':
        pageToDisplay = GuideStep3Screen();
        break;
      default:
        pageToDisplay = GuideWelcomeScreen();
    }
    return pageToDisplay;
  }
}

