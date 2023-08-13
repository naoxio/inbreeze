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
    // Create an animation controller
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Create an animation for the outer circle (progress animation)
    outerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {}); // Trigger a rebuild when the animation updates
      });
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the animation controller
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

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Calculate the number of dots
    const dotCount = 36;
    const double angleIncrement = 2 * pi / dotCount;

    for (var i = 0; i < dotCount; i++) {
      final x = center.dx + radius * cos(i * angleIncrement);
      final y = center.dy + radius * sin(i * angleIncrement);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
    // Dotted circle paint
    final dottedPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Teal arc paint
    final tealPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

  
    // Calculate how many minutes have passed
    final passedMinutes = duration.inMinutes;

    for (int i = 0; i <= passedMinutes; i++) {
      final currentRadius = maxRadius - (i * 25.0);  // 5.0 can be adjusted based on how much you want to reduce the radius for each minute
      int dotCount = 36 - i * 2;
      double angleIncrement = 2 * pi / dotCount;

      for (var j = 0; j < dotCount; j++) {
        final x = center.dx + currentRadius * cos(j * angleIncrement);
        final y = center.dy + currentRadius * sin(j * angleIncrement);
        canvas.drawCircle(Offset(x, y), 1, dottedPaint);
      }
      // If it's a completed minute, draw a full teal circle
      if (i < passedMinutes) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          -pi / 2,
          2 * pi,
          false,
          tealPaint,
        );
      } else if (i == passedMinutes) {
        // Only draw the teal arc for the current minute
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
