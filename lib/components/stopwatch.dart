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
  late Animation<double> innerAnimation;
  List<Offset> completedCircles = [];

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

    // Create an animation for the inner circle (shrink animation)
    innerAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut), // Shrink the inner circle at the end of the animation
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start the animation when the circle completes (duration reaches 1 minute)
    if (widget.duration >= Duration(minutes: 1)) {
      controller.forward(from: 0.0);
      var min = widget.duration.inMinutes - Duration(minutes: 1).inMinutes;
      // Calculate the offset for the completed circle based on the current widget.duration
      final row = min ~/ 3;
      final col = min % 3;
      completedCircles.add(Offset(col * 15.0, row * 15.0)); // Assuming each cell in the grid has 100.0 width and height
    }
  }

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      painter: TimerPainter(
        duration: widget.duration,
        outerAnimation: outerAnimation,
        innerAnimation: innerAnimation,
        completedCircles: completedCircles,
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
    final dotCount = 36;
    final double angleIncrement = 2 * 3.141592653589793 / dotCount;

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
  final Animation<double> innerAnimation;
  final List<Offset> completedCircles;

  TimerPainter({required this.duration, required this.outerAnimation, required this.innerAnimation, required this.completedCircles})
      : super(repaint: outerAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate the radius of the outer circle
    final outerRadius = min(size.width / 2, size.height / 2);

    // Calculate the sweep angle for the outer circle
    final maxMilliseconds = Duration(minutes: 1).inMilliseconds;
    final milliseconds = duration.inMilliseconds % maxMilliseconds;
    final percentage = milliseconds / maxMilliseconds;
    final sweepAngle = 2 * pi * percentage;

    // draw dotted circle
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const dotCount = 36;
    const double angleIncrement = 2 * pi / dotCount;

    for (var i = 0; i < dotCount; i++) {
      final x = center.dx + outerRadius * cos(i * angleIncrement);
      final y = center.dy + outerRadius * sin(i * angleIncrement);
      canvas.drawCircle(Offset(x, y), 1, paint);
    }


    // Draw the outer circle arc
    final outerCirclePaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      -pi / 2,
      sweepAngle,
      false,
      outerCirclePaint,
    );
    if (completedCircles.isNotEmpty) {
      // Draw the inner circles that appear when the circles complete
      for (var offset in completedCircles) {
        final innerCirclePaint = Paint()
          ..color = Colors.teal.withOpacity(0.5)
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(offset, 15, innerCirclePaint);
      }
    }
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.duration != duration || oldDelegate.completedCircles != completedCircles;
  }
}
