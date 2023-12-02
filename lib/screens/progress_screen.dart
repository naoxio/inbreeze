import 'package:flutter/material.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

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
  void _navigateToExercise() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.startNewSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Start Your Journey!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Your progress records will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToExercise,
                child: Text('Begin a Session'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BreezeBottomNav(),
      );
    }

    Future<void> showEditRoundDialog(Session session, int roundNumber, Duration duration) async {
      DateTime selectedDate = session.dateTime;
      TimeOfDay selectedTime = TimeOfDay.fromDateTime(session.dateTime);
      TextEditingController minutesController = TextEditingController(text: duration.inMinutes.toString());
      TextEditingController secondsController = TextEditingController(text: (duration.inSeconds % 60).toString());

      return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          final NavigatorState navigator = Navigator.of(dialogContext);

          return AlertDialog(
            title: Text('Edit Round $roundNumber'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Picker
                ListTile(
                  title: Text('Select Date'),
                  subtitle: Text(DateFormat.yMd().format(selectedDate)),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                // Time Picker
                ListTile(
                  title: Text('Select Time'),
                  subtitle: Text(selectedTime.format(context)),
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                ),
                // Duration Field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        decoration: InputDecoration(
                          labelText: 'Minutes',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: secondsController,
                        decoration: InputDecoration(
                          labelText: 'Seconds',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  DateTime newDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  int newMinutes = int.tryParse(minutesController.text) ?? duration.inMinutes;
                  int newSeconds = int.tryParse(secondsController.text) ?? (duration.inSeconds % 60);
                  Duration newDuration = Duration(minutes: newMinutes, seconds: newSeconds);
                  final userProvider = Provider.of<UserProvider>(context, listen: false);

                  if (session.dateTime != newDateTime) {
                    await userProvider.moveRoundToSession(session.id, roundNumber, newDateTime);
                  } else {
                    await userProvider.updateRoundDuration(session.id, roundNumber, newDuration);
                  }

                  await _loadSessions();
                  navigator.pop();
                },
              ),
            ],
          );
        },
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
                                      title: Row(
                                        children: [
                                          Text(
                                            'Round $roundNumber: ${roundDuration.inMinutes}:${roundDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                            textAlign: TextAlign.left
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.teal),
                                            onPressed: () async {
                                              await showEditRoundDialog(session, roundNumber, roundDuration);
                                              await _loadSessions();
                                            },
                                          ),
                                        ],
                                      ),
                                  
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
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