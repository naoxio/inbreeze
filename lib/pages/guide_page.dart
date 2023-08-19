
import 'package:flutter/material.dart';
import 'guide/welcome_page.dart';
import 'guide/method_page.dart';
import 'guide/guide_step1.dart';
import 'guide/guide_step2.dart';
import 'guide/guide_step3.dart';

class TutorialPage extends StatelessWidget {
  // Constructs a [TutorialPage]
  const TutorialPage({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    switch (page) {
      case '':
        pageToDisplay = GuideWelcomePage();
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
        pageToDisplay = GuideWelcomePage();
    }
    return pageToDisplay;
  }
}

