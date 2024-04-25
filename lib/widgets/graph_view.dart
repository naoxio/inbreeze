import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:localization/localization.dart';

class GraphView extends StatefulWidget {
  final Map<String, Map<String, List<Session>>> sessionsByMonthAndDay;
  final DateTime viewingMonth;
  final Function(int) onMonthChanged;

  GraphView({
    required this.sessionsByMonthAndDay,
    required this.viewingMonth,
    required this.onMonthChanged,
  });

  @override
  GraphViewState createState() => GraphViewState();
}

class GraphViewState extends State<GraphView> {
  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> barGroups = [];

    if (widget.sessionsByMonthAndDay.isNotEmpty) {
      String currentMonthKey =
          DateFormat('yyyy-MM').format(widget.viewingMonth);
      Map<String, List<Session>>? currentMonthSessions =
          widget.sessionsByMonthAndDay[currentMonthKey];

      if (currentMonthSessions != null) {
        List<String> sortedDays = currentMonthSessions.keys.toList()..sort();

        for (int i = 0; i < sortedDays.length; i++) {
          String dayKey = sortedDays[i];
          List<Session> sessions = currentMonthSessions[dayKey]!..reversed;

          int totalDurationInSeconds = sessions.fold(0, (total, session) {
            return total + session.totalDurationInSeconds();
          });

          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: totalDurationInSeconds.toDouble(),
                  color: Colors.teal,
                  width: 22,
                ),
              ],
            ),
          );
        }
      }
    }

    return barGroups;
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool _isEarliestMonth() {
    if (widget.sessionsByMonthAndDay.isEmpty) {
      return true;
    }
    String earliestMonthKey = widget.sessionsByMonthAndDay.keys
        .reduce((a, b) => a.compareTo(b) < 0 ? a : b);
    DateTime earliestMonth = DateFormat('yyyy-MM').parse(earliestMonthKey);
    return widget.viewingMonth.year == earliestMonth.year &&
        widget.viewingMonth.month == earliestMonth.month;
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = _generateBarGroups();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Center(
          child: Text(DateFormat('MMMM yyyy').format(widget.viewingMonth),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                alignment: BarChartAlignment.spaceAround,
                maxY: (((barGroups.fold(0.0, (double max, group) {
                                      double groupMax = group.barRods.fold(
                                          0.0,
                                          (m, rod) =>
                                              rod.toY > m ? rod.toY : m);
                                      return groupMax > max ? groupMax : max;
                                    }) +
                                    10.0) /
                                10)
                            .ceil() *
                        10)
                    .toDouble(),
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
                      getTitlesWidget: (double value, TitleMeta meta) {
                        String dayKey = widget
                            .sessionsByMonthAndDay[DateFormat('yyyy-MM')
                                .format(widget.viewingMonth)]!
                            .keys
                            .toList()
                            .reversed
                            .toList()[value.toInt()];
                        DateTime day = DateFormat('yyyy-MM-dd').parse(dayKey);
                        return Text(DateFormat('d').format(day),
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      'duration'.i18n(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(_formatDuration(value.toInt()),
                              style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: true),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String dayKey = widget
                          .sessionsByMonthAndDay[DateFormat('yyyy-MM')
                              .format(widget.viewingMonth)]!
                          .keys
                          .toList()
                          .reversed
                          .toList()[groupIndex];
                      DateTime day = DateFormat('yyyy-MM-dd').parse(dayKey);
                      String formattedDate = DateFormat('d MMM').format(day);
                      String formattedDuration =
                          _formatDuration(rod.toY.toInt());
                      return BarTooltipItem(
                        '$formattedDate\n$formattedDuration',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:
                  _isEarliestMonth() ? null : () => widget.onMonthChanged(-1),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: widget.viewingMonth.month == DateTime.now().month &&
                      widget.viewingMonth.year == DateTime.now().year
                  ? null
                  : () => widget.onMonthChanged(1),
            ),
          ],
        ),
      ],
    );
  }
}
