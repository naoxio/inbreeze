import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

ThemeData darkGreenishBlueTheme() {
  return ThemeData(
    primaryColor: Color(0xFF0097A7),
    primaryColorDark: Color(0xFF00738D),
    hintColor: Color(0xFFF4FFAF),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme(
      primary: Color(0xFF0097A7),
      onPrimary: Colors.black,
      secondary: Colors.tealAccent,
      onSecondary: Colors.black12,
      error: Colors.red,
      onError: Colors.redAccent,
      onBackground: Colors.black12,
      surface: Colors.teal,
      onSurface: Colors.tealAccent,
      brightness: Brightness.dark,
      background: Color(0xFF212933),
      tertiary: Color(0xFF3B4353),
    ),
  );
}

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
          title: 'Inner Breeze',
          home: MyHomePage(),
          theme: darkGreenishBlueTheme()),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var progress = <DateTime>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Scaffold(
          body: MainPage(),
        );
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'Progress'),
          ],
        ),
        body: TabBarView(
          children: [
            // Today tab
            TodayView(),
            // Progress tab
            ProgressView(appState: appState),
          ],
        ),
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appState.progress.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.show_chart),
          title: Text(appState.progress[index].toString()),
        );
      },
    );
  }
}

class TodayView extends StatelessWidget {
  const TodayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                var roundsCompleted = 0;
                return Text(
                  'Rounds completed: $roundsCompleted',
                  style: TextStyle(fontSize: 24.0),
                );
              case 1:
                var averageRoundDuration = 0;
                return Text(
                  'Average round duration: ${averageRoundDuration.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24.0),
                );
              case 2:
                return TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
