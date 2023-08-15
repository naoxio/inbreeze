import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final int volume;
  final int tempo; 
  final int? breathsDone; 

  AnimatedBreathingCircle({
    required this.volume,
    required this.tempo,
    this.breathsDone,
  });
  
  @override
  AnimatedBreathingCircleState createState() => AnimatedBreathingCircleState();
}

enum BreathingState { inhale, exhale }

class AnimatedBreathingCircleState extends State<AnimatedBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late AudioPlayer _audioPlayer;
  BreathingState _currentBreathingState = BreathingState.inhale;
  bool _isDisposed = false;


  @override
  void initState() {
    var duration = Duration(milliseconds: 2860 - (widget.tempo * 542).toInt());

    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: duration, // Use the tempo parameter
    );
    
    _radiusAnimation = Tween<double>(begin: 40, end: 72).animate(_controller);

    _audioPlayer = AudioPlayer();

    _controller.addStatusListener((status) {
      var newDuration = Duration(milliseconds: 2860 - (widget.tempo * 542).toInt());
      
      if (_controller.duration != newDuration && _controller.status == AnimationStatus.forward) {
        _controller.stop();
        _controller.duration = newDuration;
        _controller.reset();
        _controller.forward();
        _controller.repeat(reverse: true);
      }

  
      if (status == AnimationStatus.forward && _currentBreathingState != BreathingState.inhale) {
        _currentBreathingState = BreathingState.inhale;
        _playAudio('sounds/breath-in.mp3');
      } else if (status == AnimationStatus.reverse && _currentBreathingState != BreathingState.exhale) {
        _currentBreathingState = BreathingState.exhale;
        _playAudio('sounds/breath-out.mp3');
      }
    });
  }
  @override
  void didUpdateWidget(AnimatedBreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.breathsDone != null && widget.breathsDone! >= 0 && oldWidget.breathsDone != widget.breathsDone) {
      _controller.repeat(reverse: true);
    }
  }
  Future<void> _playAudio(String assetPath) async {
    if (_isDisposed) return;
    if (_audioPlayer.state == PlayerState.playing) return;

    await _audioPlayer.setSource(AssetSource(assetPath));
    await _audioPlayer.setVolume(widget.volume / 100); // Use the volume parameter
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _isDisposed = true;

    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: BreathingCircle(_radiusAnimation, number: widget.breathsDone),
      ),
    );
  }
}

class BreathingCircle extends CustomPainter {
  final Animation<double> _animation;
  final int? number;

  BreathingCircle(this._animation, {this.number}) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    var paint2 = Paint();
    paint2.color = Colors.tealAccent;

    double radius = _animation.value;
    canvas.drawCircle(Offset(0.0, 100.0), 72, paint);
    canvas.drawCircle(Offset(0.0, 100.0), radius, paint2);
  
    if (number != null) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: number?.abs().toString(), style: TextStyle(color: Colors.black, fontSize: 32.0)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 100.0 - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant BreathingCircle oldDelegate) {
    return oldDelegate.number != number;
  }
}
