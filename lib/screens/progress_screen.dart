import 'package:flutter/material.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/models/session.dart';

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

    // Grouping sessions by date
    for (var session in allSessions) {
      final date = DateTime(session.dateTime.year, session.dateTime.month, session.dateTime.day);
      if (!sessionsByDate.containsKey(date)) {
        sessionsByDate[date] = [];
      }
      sessionsByDate[date]!.add(session);
    }

    setState(() {});
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
                'Progress',
                style: BreezeStyle.header,
              ),
            ),
            SizedBox(height: 20),
            ...sessionsByDate.entries.map((entry) {
              final date = entry.key;
              final sessions = entry.value;
              return Column(
                children: sessions.map((session) {
                  return ExpansionTile(
                    title: Text('${date.toLocal()} - ${session.rounds.length} rounds'),
                    children: session.rounds.entries.map((roundEntry) {
                      final roundNumber = roundEntry.key;
                      final roundDuration = roundEntry.value;
                      return ListTile(
                        title: Text('Round $roundNumber'),
                        subtitle: Text('${roundDuration.inMinutes}:${roundDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }
}
