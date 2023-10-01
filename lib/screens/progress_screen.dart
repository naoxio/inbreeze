import 'package:flutter/material.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}
class _ProgressScreenState extends State<ProgressScreen> {
  Map<DateTime, List<Session>> sessionsByDate = {};

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }


  Future<void> _loadSessions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allSessions = await userProvider.getAllSessions();

    Map<DateTime, List<Session>> newSessionsByDate = {}; // Declare a new map here

    // Grouping sessions by date
    for (var session in allSessions) {
      final date = DateTime(session.dateTime.year, session.dateTime.month, session.dateTime.day);
      if (!newSessionsByDate.containsKey(date)) {
        newSessionsByDate[date] = [];
      }
      newSessionsByDate[date]!.add(session);
    }

    setState(() {
      sessionsByDate = newSessionsByDate; // Assign the newly populated map here
    });
  }

  String formatYear(DateTime date) {
    return date.year.toString();
  }

  String formatMonth(DateTime date) {
    return DateFormat.MMM().format(date);
  }

  String formatDay(DateTime date) {
    String day = DateFormat.d().format(date);
    String suffix = day.endsWith('1') ? 'st' : (day.endsWith('2') ? 'nd' : (day.endsWith('3') ? 'rd' : 'th'));
    return '$day$suffix';
  }
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String? year;
    if (sessionsByDate.keys.isNotEmpty) {
      year = formatYear(sessionsByDate.keys.first);
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (sessionsByDate.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Start meditating now', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        bottomNavigationBar: BreezeBottomNav(),
      );
    }

    return Scaffold(
      appBar: BreezeAppBar(title: 'Progress View'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (year != null)
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  year,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                children: [
                  ...sessionsByDate.entries.fold<List<Widget>>([], (previousValue, entry) {
                    final date = entry.key;
                    final sessions = entry.value;
                    List<Widget> widgets = [];

                    widgets.add(
                      ExpansionTile(
                        initiallyExpanded: date.isBefore(today) || date.isAtSameMomentAs(today),
                        title: Text(
                          formatMonth(date),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        children: [
                          ExpansionTile(
                            initiallyExpanded: date.isAtSameMomentAs(today) || sessionsByDate.keys.first.isAtSameMomentAs(date),
                            title: Text(
                              formatDay(date),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Text('${sessions.length} ${sessions.length == 1 ? 'session' : 'sessions'}'),
                            children: [
                              for (var session in sessions.reversed)
                                ExpansionTile(
                                  initiallyExpanded: sessions.indexOf(session) == 0, 
                                  title: Text(
                                    DateFormat('HH:mm').format(session.dateTime),
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text('${session.rounds.length} ${session.rounds.length == 1 ? 'round' : 'rounds'}'),
                                  children: session.rounds.entries.map((roundEntry) {
                                    final roundNumber = roundEntry.key;
                                    final roundDuration = roundEntry.value;
                                    return ListTile(
                                      title: Text(
                                        'Round $roundNumber: ${roundDuration.inMinutes}:${roundDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                        textAlign: TextAlign.left
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.teal),
                                        onPressed: () async {
                                          await userProvider.deleteRound(roundNumber, session.id);
                                          await _loadSessions();  // Reload the sessions after deletion.
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ]
                          )
                        ],
                      ),
                    );

                    return widgets;
                  }),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
}

}