import 'package:flutter/material.dart';

class BreathingCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    var paint2 = Paint();
    paint2.color = Colors.tealAccent;
    canvas.drawCircle(Offset(0.0, 90.0), 70, paint);
    canvas.drawCircle(Offset(0.0, 90.0), 40, paint2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) 
{//false : paint call might be optimized away.
    return false;
  }
}