import 'dart:math';
import 'package:flutter/material.dart';

class CustomTimer extends StatefulWidget {
  final Duration duration;

  CustomTimer({required this.duration});

  @override
  CustomTimerState createState() => CustomTimerState();
}

class CustomTimerState extends State<CustomTimer> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> outerAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    outerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: TimerPainter(
        duration: widget.duration,
        outerAnimation: outerAnimation,
      ),
      child: Container(),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Duration duration;
  final Animation<double> outerAnimation;

  TimerPainter({required this.duration, required this.outerAnimation})
      : super(repaint: outerAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width / 2, size.height / 2);
    final maxMilliseconds = Duration(minutes: 1).inMilliseconds;
    final milliseconds = duration.inMilliseconds % maxMilliseconds;
    final percentage = milliseconds / maxMilliseconds;
    final sweepAngle = 2 * pi * percentage;
    final dottedPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final tealPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final passedMinutes = duration.inMinutes;

    for (int i = 0; i <= passedMinutes; i++) {
      final currentRadius = maxRadius - (i * 32.0);
      int dotCount = 25 - i * 4;
      double angleIncrement = 2 * pi / dotCount;

      for (var j = 0; j < dotCount; j++) {
        final x = center.dx + currentRadius * cos(j * angleIncrement);
        final y = center.dy + currentRadius * sin(j * angleIncrement);
        canvas.drawCircle(Offset(x, y), 1, dottedPaint);
      }

      if (i < passedMinutes) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          -pi / 2,
          2 * pi,
          false,
          tealPaint,
        );
      } else if (i == passedMinutes) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          -pi / 2,
          sweepAngle,
          false,
          tealPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.duration != duration;
  }
}
