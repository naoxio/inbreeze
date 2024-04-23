import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sessionsByMonthAndDay.entries.map((monthEntry) {
          return _buildMonthSection(monthEntry.key, monthEntry.value);
        }).toList(),
      ),
    );
  }

  Widget _buildMonthSection(
      String monthYearKey, Map<String, List<Session>> sessionsByDay) {
    DateTime monthYear = DateFormat('yyyy-MM').parse(monthYearKey);
    String monthName = DateFormat.yMMMM().format(monthYear);

    List<String> sortedDays = sessionsByDay.keys.toList();
    sortedDays.sort((a, b) => b.compareTo(a));

    return ExpansionTile(
      initiallyExpanded: monthYearKey == latestMonthKey,
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
      initiallyExpanded: dayKey == latestDayKey,
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
            await _loadSessions();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await Provider.of<UserProvider>(context, listen: false)
                .deleteRound(roundNumber, session.id);
            await _loadSessions();
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

                await _loadSessions();
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _generateDataPoints() {
    DateTime lastDayOfMonth =
        DateTime(_viewingMonth.year, _viewingMonth.month + 1, 0);

    List<FlSpot> spots = List.generate(lastDayOfMonth.day, (index) {
      DateTime day =
          DateTime(_viewingMonth.year, _viewingMonth.month, index + 1);
      return FlSpot(day.millisecondsSinceEpoch.toDouble(), 0);
    });

    if (sessionsByMonthAndDay.isNotEmpty) {
      String currentMonthKey = DateFormat('yyyy-MM').format(_viewingMonth);
      Map<String, List<Session>>? currentMonthSessions =
          sessionsByMonthAndDay[currentMonthKey];

      if (currentMonthSessions != null) {
        currentMonthSessions.forEach((dayKey, sessions) {
          DateTime day = DateFormat('yyyy-MM-dd').parse(dayKey);
          int dayIndex =
              day.day - 1; // Adjust day to zero-based index for the list
          int totalSeconds = sessions.fold(0, (total, session) {
            return total + session.totalDurationInSeconds();
          });
          spots[dayIndex] = FlSpot(
              day.millisecondsSinceEpoch.toDouble(), totalSeconds.toDouble());
        });
      }
    }

    return spots;
  }

  Widget _buildGraphView() {
    List<FlSpot> spots = _generateDataPoints();

    double minX = spots.first.x;
    double maxX = spots.last.x;
    double maxY = spots.map((spot) => spot.y).reduce(max) * 1.1;
    double intervalY = maxY < 10 ? 1 : (maxY / 10).ceil().toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(DateFormat('MMMM yyyy').format(_viewingMonth),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      'days'.i18n(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text(DateFormat('dd').format(date),
                            style: const TextStyle(fontSize: 10));
                      },
                      interval: 86400000 * 5,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      'seconds'.i18n(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}',
                          style: const TextStyle(fontSize: 10)),
                      interval: intervalY,
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                minX: minX,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _changeMonth(-1),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _viewingMonth.month == DateTime.now().month &&
                      _viewingMonth.year == DateTime.now().year
                  ? null
                  : () => _changeMonth(1),
            ),
          ],
        ),
      ],
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _viewingMonth = DateTime(_viewingMonth.year, _viewingMonth.month + delta);
      _loadSessions(); // Reload sessions for the new month
    });
  }
}
