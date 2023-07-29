import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer.dart';
import 'app_state.dart';
import 'pages/tutorial_page.dart';
import 'pages/title_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inner Breeze',
        home: MyHomePage(),
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Widget pageToDisplay;

    // Conditionally set the page to display based on the selectedIndex using switch-case
    switch (appState.selectedIndex) {
      case 0:
        pageToDisplay = TitlePage();
        break;
      case 1:
        pageToDisplay = TutorialPage();
        break;
      case 2:
        pageToDisplay = TimerPage();
        break;
      default:
        pageToDisplay =
            TitlePage(); // Set a default page in case selectedIndex is not handled
    }

    return LayoutBuilder(
      builder: (context, constrains) {
        return Scaffold(
          body:
              pageToDisplay, // Render the appropriate page based on the selectedIndex
        );
      },
    );
  }
}

