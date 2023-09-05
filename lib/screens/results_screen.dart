import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class ResultsScreen extends StatefulWidget {
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool saveProgress = true;
  int rounds = 0;
  Map<int, Duration> allRoundDurations = {};
  
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.loadSessionData(['rounds']).then((sessionData) {
      setState(() {
        rounds = sessionData['rounds'] ?? 0;
        if (rounds == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
        }
      });
    });
    userProvider.loadRoundDurations().then((roundDurations) {
      setState(() {
        allRoundDurations = roundDurations;
        print('all round');
        print(allRoundDurations);
      });
    });
  }

  Future<void> _handleClose() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!saveProgress) {
      await userProvider.clearCurrentSession();
      await userProvider.deleteSessionData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: allRoundDurations.length,
              itemBuilder: (context, index) {
                int roundNumber = index + 1;
                Duration duration = allRoundDurations[roundNumber]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '$roundNumber',
                        style: BreezeStyle.body,
                      ),
                      Row(
                        children: [
                          Text(
                            '${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                            style: BreezeStyle.body,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.teal),
                           onPressed: () async {
                              await userProvider.deleteRound(roundNumber);
                              final updatedSessionData = await userProvider.loadSessionData(['rounds']);
                              setState(() {
                                  rounds = updatedSessionData['rounds'] ?? 0;
                                  allRoundDurations.remove(roundNumber);
                              });
                            }
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),     
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text("Save Progress"),
              value: saveProgress,
              onChanged: (rounds > 0)
                  ? (bool value) {
                      setState(() {
                        saveProgress = value;
                      });
                    }
                  : null,
              activeColor: Colors.teal,
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                onPressed: () {
                  _handleClose();
                  context.go('/home');
                },
                child: Text(
                  'Close',
                  style: BreezeStyle.bodyBig
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
