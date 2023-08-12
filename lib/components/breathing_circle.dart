import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final double volume;
  final double tempo; 
  final bool isReal; 

  AnimatedBreathingCircle({
    required this.volume,
    required this.tempo,
    this.isReal = false,
  });
  
  @override
  _AnimatedBreathingCircleState createState() => _AnimatedBreathingCircleState();
}

class _AnimatedBreathingCircleState extends State<AnimatedBreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late AudioPlayer _audioPlayer;
  bool _isPlayingInhale = false;
  bool _isPlayingExhale = false;

  int breathsDone = 0;
  int maxBreaths = 30; // Default value

  DateTime? _startTime;
  Duration get _breathCycleDuration => Duration(milliseconds: 2860 - (widget.tempo * 542).toInt()) * 2;

  @override
  void initState() {
    var duration = Duration(milliseconds: 2860 - (widget.tempo * 542).toInt());

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: duration, // Use the tempo parameter
    )..repeat(reverse: true);

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

      if (status == AnimationStatus.forward && !_isPlayingInhale) {
        _isPlayingInhale = true;
        _isPlayingExhale = false;
        _playAudio('sounds/breath-in.mp3');
      } else if (status == AnimationStatus.reverse && !_isPlayingExhale) {
        _isPlayingExhale = true;
        _isPlayingInhale = false;
        _playAudio('sounds/breath-out.mp3');
      }

    
    });
    if (widget.isReal) {
        _startTime = DateTime.now();
      _controller.addListener(_updateBreathCount);
    }
    _loadMaxBreathsFromPreferences();
  }

  void _updateBreathCount() {
    if (_startTime != null) {
      final elapsedTime = DateTime.now().difference(_startTime!);
      final breaths = (elapsedTime.inMilliseconds / _breathCycleDuration.inMilliseconds).floor();

      if (breathsDone != breaths) {
        setState(() {
          breathsDone = breaths;
        });

        if (breathsDone >= maxBreaths) {
          _navigateToNextExercise();
        }
      }
    }
  }
  Future<void> _loadMaxBreathsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxBreaths = prefs.getInt('breaths')?.toInt() ?? 30;
    });
  }

  void _navigateToNextExercise() {
    context.go('/exercise/step2');
  }

  Future<void> _playAudio(String assetPath) async {
    await _audioPlayer.setSource(AssetSource(assetPath));
    await _audioPlayer.setVolume(widget.volume / 100); // Use the volume parameter
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _controller.removeListener(_updateBreathCount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: BreathingCircle(_radiusAnimation, breathsDone: breathsDone, isReal: widget.isReal ),
      ),
    );
  }
}

class BreathingCircle extends CustomPainter {
  final Animation<double> _animation;
  final int breathsDone;
  final bool isReal;

  BreathingCircle(this._animation, {required this.breathsDone, required this.isReal}) : super(repaint: _animation);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    var paint2 = Paint();
    paint2.color = Colors.tealAccent;

    double radius = _animation.value;
    canvas.drawCircle(Offset(0.0, 100.0), 72, paint);
    canvas.drawCircle(Offset(0.0, 100.0), radius, paint2);
  
    if (isReal) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: breathsDone.toString(), style: TextStyle(color: Colors.black, fontSize: 32.0)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 100.0 - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
