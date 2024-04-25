import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:inner_breeze/widgets/session_list_view.dart';
import 'package:inner_breeze/widgets/graph_view.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, Map<String, List<Session>>> sessionsByMonthAndDay = {};
  String? latestMonthKey;
  String? latestDayKey;
  late DateTime _viewingMonth;

  @override
  void initState() {
    super.initState();
    _viewingMonth = DateTime.now();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allSessions = await userProvider.getAllSessions();

    Map<String, Map<String, List<Session>>> tempSessionsByMonthAndDay = {};
    DateTime? latestDate;

    for (var session in allSessions) {
      DateTime sessionDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(session.id));
      String monthYearKey = DateFormat('yyyy-MM').format(sessionDate);
      String dayKey = DateFormat('yyyy-MM-dd').format(sessionDate);

      if (!tempSessionsByMonthAndDay.containsKey(monthYearKey)) {
        tempSessionsByMonthAndDay[monthYearKey] = {};
      }
      if (!tempSessionsByMonthAndDay[monthYearKey]!.containsKey(dayKey)) {
        tempSessionsByMonthAndDay[monthYearKey]![dayKey] = [];
      }
      tempSessionsByMonthAndDay[monthYearKey]![dayKey]!.add(session);

      if (latestDate == null || sessionDate.isAfter(latestDate)) {
        latestDate = sessionDate;
        latestMonthKey = monthYearKey;
        latestDayKey = dayKey;
      }
    }

    setState(() {
      sessionsByMonthAndDay = tempSessionsByMonthAndDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BreezeAppBar(title: 'progress_title'.i18n()),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'sessions'.i18n()),
                Tab(text: 'graph'.i18n()),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildSessionList(),
                  _buildGraphView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'start_journey'.i18n(),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'progress_records_info'.i18n(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false)
                  .startNewSession();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/exercise/step1');
              });
            },
            child: Text('begin_session_button'.i18n()),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    if (sessionsByMonthAndDay.isEmpty) {
      return _buildEmptyState();
    }

    return SessionListView(
      sessionsByMonthAndDay: sessionsByMonthAndDay,
      latestMonthKey: latestMonthKey,
      latestDayKey: latestDayKey,
      onSessionsUpdated: _loadSessions,
    );
  }

  Widget _buildGraphView() {
    return GraphView(
      sessionsByMonthAndDay: sessionsByMonthAndDay,
      viewingMonth: _viewingMonth,
      onMonthChanged: (delta) {
        setState(() {
          _viewingMonth =
              DateTime(_viewingMonth.year, _viewingMonth.month + delta);
          _loadSessions();
        });
      },
    );
  }
}
