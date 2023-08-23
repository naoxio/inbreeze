
import 'package:flutter/material.dart';
import '../screens/guide/guide_welcome_screen.dart';
import '../screens/guide/method_page.dart';
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
        pageToDisplay = MethodPage();
        break;
      case 'step1':
        pageToDisplay = GuideStep1Page();
        break;
      case 'step2':
        pageToDisplay = GuideStep2Page();
        break;
      case 'step3':
        pageToDisplay = GuideStep3Page();
        break;
      default:
        pageToDisplay = GuideWelcomeScreen();
    }
    return pageToDisplay;
  }
}

