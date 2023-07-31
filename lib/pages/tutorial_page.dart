
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialPage extends StatelessWidget {
  // Constructs a [TutorialPage]
  const TutorialPage({required this.page, super.key});
  
  final String page;

  @override
  Widget build(BuildContext context) {
    Widget pageToDisplay;
    print(page);
    switch (page) {
      case '':
        pageToDisplay = WelcomePage();
        break;
      case 'method':
        pageToDisplay = MethodPage();
        break;
      default:
        pageToDisplay = WelcomePage();
    }
    return pageToDisplay;
  }
}

class PageLayout extends StatelessWidget {
  final String buttonText;
  final String nextRoute;
  final VoidCallback onPressed;
  final Widget column;

  PageLayout({
    required this.column,
    required this.buttonText,
    required this.nextRoute,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 420,
              child: column
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 64,
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      buttonText: 'Next',
      nextRoute: '/guide/method',
      onPressed: () {
        context.go('/guide/method');
      },
      column: Column(
        children: [
          Text(
            'Namaste',
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: Image.asset(
              'assets/tuto-01-dark.png',
              width: double.infinity,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "This easy yet potent breathing technique promises profound inner peace, offering a sanctuary of serenity amidst life's hectic pace.",
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'To ensure your safety, practice either lying down or sitting in a comfortable position.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          
        ],
      ),
    );
  }
}

class MethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      buttonText: 'Next',
      nextRoute: '/guide/step1',
      onPressed: () {
        context.go('/guide/step1');
      },
      column: Column(
        children: [
          Text(
            'Method',
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Simply follow 4 steps:',
            style: TextStyle(
              fontSize: 22.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '''
  1. Inhale and exhale rhythmically for 30 breaths.
  2. Exhale and hold your breath.
  3. Inhale deeply and hold for 15 seconds.
  4. Exhale and repeat step 1

  Do 3-10 rounds of the process.
            ''',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'The next pages will let you personalize your experience.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}