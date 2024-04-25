import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inner_breeze/models/session.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
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
  _GraphViewState createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  List<FlSpot> _generateDataPoints() {
    DateTime lastDayOfMonth =
        DateTime(widget.viewingMonth.year, widget.viewingMonth.month + 1, 0);

    List<FlSpot> spots = List.generate(lastDayOfMonth.day, (index) {
      DateTime day = DateTime(
          widget.viewingMonth.year, widget.viewingMonth.month, index + 1);
      return FlSpot(day.millisecondsSinceEpoch.toDouble(), 0);
    });

    if (widget.sessionsByMonthAndDay.isNotEmpty) {
      String currentMonthKey =
          DateFormat('yyyy-MM').format(widget.viewingMonth);
      Map<String, List<Session>>? currentMonthSessions =
          widget.sessionsByMonthAndDay[currentMonthKey];

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

  @override
  Widget build(BuildContext context) {
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
          child: Text(DateFormat('MMMM yyyy').format(widget.viewingMonth),
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
              onPressed: () => widget.onMonthChanged(-1),
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
