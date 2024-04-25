import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:intl/intl.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class SessionListView extends StatefulWidget {
  final Map<String, Map<String, List<Session>>> sessionsByMonthAndDay;
  final String? latestMonthKey;
  final String? latestDayKey;
  final VoidCallback onSessionsUpdated;

  SessionListView({
    required this.sessionsByMonthAndDay,
    required this.latestMonthKey,
    required this.latestDayKey,
    required this.onSessionsUpdated,
  });

  @override
  SessionListViewState createState() => SessionListViewState();
}

class SessionListViewState extends State<SessionListView> {
  Widget _buildMonthSection(
      String monthYearKey, Map<String, List<Session>> sessionsByDay) {
    DateTime monthYear = DateFormat('yyyy-MM').parse(monthYearKey);
    String monthName = DateFormat.yMMMM().format(monthYear);

    List<String> sortedDays = sessionsByDay.keys.toList();
    sortedDays.sort((a, b) => b.compareTo(a));

    return ExpansionTile(
      initiallyExpanded: monthYearKey == widget.latestMonthKey,
      title: Text(
        monthName,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: sortedDays.map((dayKey) {
        return _buildDaySection(dayKey, sessionsByDay[dayKey]!);
      }).toList(),
    );
  }

  Widget _buildDaySection(String dayKey, List<Session> sessions) {
    DateTime dayDate = DateFormat('yyyy-MM-dd').parse(dayKey);
    String dayName = DateFormat('d E').format(dayDate);

    sessions.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

    return ExpansionTile(
      initiallyExpanded: dayKey == widget.latestDayKey,
      title: Text(dayName, style: TextStyle(fontSize: 18)),
      children: sessions.map((session) => _buildSessionTile(session)).toList(),
    );
  }

  Widget _buildSessionTile(Session session) {
    DateTime sessionDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(session.id));
    String sessionTime = DateFormat.jm().format(sessionDate);

    return ExpansionTile(
      leading: Icon(Icons.access_time),
      title: Text(sessionTime),
      subtitle: Text('${'rounds_label'.i18n()}: ${session.rounds.length}'),
      children: session.rounds.entries.map((roundEntry) {
        return ListTile(
          title: Text(
              '${'round_label'.i18n()} ${roundEntry.key}: ${_formatDuration(roundEntry.value)}'),
          trailing: _buildEditDeleteButtons(
              session, roundEntry.key, roundEntry.value),
        );
      }).toList(),
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes > 0 ? "${duration.inMinutes} mins, " : ""}${duration.inSeconds % 60} secs';
  }

  Row _buildEditDeleteButtons(
      Session session, int roundNumber, Duration roundDuration) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit, color: Colors.teal),
          onPressed: () async {
            await showEditRoundDialog(session, roundNumber, roundDuration);
            widget.onSessionsUpdated();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await Provider.of<UserProvider>(context, listen: false)
                .deleteRound(roundNumber, session.id);
            widget.onSessionsUpdated();
          },
        ),
      ],
    );
  }

  Future<void> showEditRoundDialog(
      Session session, int roundNumber, Duration duration) async {
    DateTime sessionDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(session.id));
    DateTime selectedDate = sessionDateTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(sessionDateTime);

    TextEditingController minutesController =
        TextEditingController(text: duration.inMinutes.toString());
    TextEditingController secondsController =
        TextEditingController(text: (duration.inSeconds % 60).toString());

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final NavigatorState navigator = Navigator.of(dialogContext);

        return AlertDialog(
          title: Text('edit_round'.i18n() + roundNumber.toString()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Picker
              ListTile(
                title: Text('select_date'.i18n()),
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
                title: Text('select_time'.i18n()),
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
                        labelText: 'minutes'.i18n(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: secondsController,
                      decoration: InputDecoration(
                        labelText: 'seconds'.i18n(),
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
              child: Text('cancel_button'.i18n()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('save_button'.i18n()),
              onPressed: () async {
                DateTime newDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                int newTimestamp = newDateTime.millisecondsSinceEpoch;

                int newMinutes =
                    int.tryParse(minutesController.text) ?? duration.inMinutes;
                int newSeconds = int.tryParse(secondsController.text) ??
                    (duration.inSeconds % 60);
                Duration newDuration =
                    Duration(minutes: newMinutes, seconds: newSeconds);
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                if (int.parse(session.id) != newTimestamp) {
                  await userProvider.moveRoundToSession(
                      session.id, roundNumber, newTimestamp);
                } else {
                  await userProvider.updateRoundDuration(
                      session.id, roundNumber, newDuration);
                }

                widget.onSessionsUpdated();
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.sessionsByMonthAndDay.entries.map((monthEntry) {
          return _buildMonthSection(monthEntry.key, monthEntry.value);
        }).toList(),
      ),
    );
  }
}
