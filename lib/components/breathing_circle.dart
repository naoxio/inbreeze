import 'package:flutter/material.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  @override
  _AnimatedBreathingCircleState createState() => _AnimatedBreathingCircleState();
}

class _AnimatedBreathingCircleState extends State<AnimatedBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 40, end: 70).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: BreathingCircle(_radiusAnimation),
      ),
    );
  }
}

class BreathingCircle extends CustomPainter {
  final Animation<double> _animation;

  BreathingCircle(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    var paint2 = Paint();
    paint2.color = Colors.tealAccent;

    double radius = _animation.value;
    canvas.drawCircle(Offset(0.0, 100.0), 70, paint);
    canvas.drawCircle(Offset(0.0, 100.0), radius, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
