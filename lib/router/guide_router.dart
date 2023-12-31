
import 'package:flutter/material.dart';
import 'package:inner_breeze/screens/guide/guide_welcome_screen.dart';
import 'package:inner_breeze/screens/guide/guide_method_screen.dart';
import 'package:inner_breeze/screens/guide/guide_step1.dart';
import 'package:inner_breeze/screens/guide/guide_step2.dart';
import 'package:inner_breeze/screens/guide/guide_step3.dart';
import 'package:inner_breeze/screens/guide/guide_language_screen.dart';

class GuideRouter extends StatelessWidget {
  // Constructs a [TutorialPage]
  const GuideRouter({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case 'lang':
        pageToDisplay = LanguageSelectionScreen();
        break;
      case 'welcome':
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

