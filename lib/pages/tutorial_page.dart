
import 'package:flutter/material.dart';
import 'tutorial/welcome_page.dart';
import 'tutorial/method_page.dart';
import 'tutorial/step1_page.dart';
import 'tutorial/step2_page.dart';

class TutorialPage extends StatelessWidget {
  // Constructs a [TutorialPage]
  const TutorialPage({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case '':
        pageToDisplay = WelcomePage();
        break;
      case 'method':
        pageToDisplay = MethodPage();
        break;
      case 'step1':
        pageToDisplay = Step1Page();
        break;
      case 'step2':
        pageToDisplay = Step2Page();
        break;
      default:
        pageToDisplay = WelcomePage();
    }
    return pageToDisplay;
  }
}

