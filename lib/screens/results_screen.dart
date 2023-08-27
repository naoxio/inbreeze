import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int rounds = 1;
  Map<int, Duration> roundDurations = {}; 
  String? _uniqueId;

  @override
  void initState() {
    super.initState();

    print('results');
    _loadDataFromPreferences();
  }


  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _uniqueId = prefs.getString('uniqueId');
      rounds = prefs.getInt('rounds') ?? 0;

      for (int i = 1; i <= rounds; i++) {
        final key = '$_uniqueId/$i';
        final durationInMillis = prefs.getInt(key);
        if (durationInMillis != null) {
          roundDurations[i] = Duration(milliseconds: durationInMillis);
        }
        print(key);
        print(durationInMillis);
      }

      print(rounds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Results',
                style: BreezeStyle.header,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Rounds Completed: $rounds',
              style: BreezeStyle.bodyBig,
            ),
            ListView.builder(
              shrinkWrap: true, // required as ListView is inside a Column
              itemCount: roundDurations.length,
              itemBuilder: (context, index) {
                int roundNumber = index + 1;
                Duration duration = roundDurations[roundNumber]!;
                return ListTile(
                  title: Text('Round $roundNumber'),
                  subtitle: Text('${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 52,
          child: TextButton(
            onPressed: () {
              context.go('/home');
            },
            child: Text('Close'),
          ),
        ),
      ),
    );
  }
}