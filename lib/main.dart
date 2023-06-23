import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'timer.dart';
import 'app_state.dart';

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
        pageToDisplay = MainPage();
        break;
      case 1:
        pageToDisplay = TimerPage();
        break;
      default:
        pageToDisplay =
            MainPage(); // Set a default page in case selectedIndex is not handled
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

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
          title: Center(
            child: Text(
              'Time to breathe'.toUpperCase(),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Progress'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Today tab
            TodayView(),
            // Progress tab
            ProgressView(appState: appState),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
            appState.changeIndex(1),
          },
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

class TodayView extends StatefulWidget {
  TodayView({
    super.key,
  });

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  var roundsCompleted = 0;

  var averageRoundDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SizedBox(
          width: 300,
          child: ListView(
            children: [
              Text(
                'Today'.toUpperCase(),
                style: TextStyle(fontSize: 32),
              ),
              Text(
                '$roundsCompleted rounds completed',
                style: TextStyle(fontSize: 24.0),
              ),
              Text(
                '${averageRoundDuration.toStringAsFixed(2)} average round duration',
                style: TextStyle(fontSize: 24.0),
              ),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now(),
                focusedDay: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
