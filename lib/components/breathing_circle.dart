import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final double volume; // New parameter for audio volume
  final double tempo;  // New parameter for animation speed

  AnimatedBreathingCircle({required this.volume, required this.tempo});

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

  @override
  void initState() {
    var duration = Duration(milliseconds: 2860 - (widget.tempo * 542).toInt());

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: duration, // Use the tempo parameter
    )..repeat(reverse: true);

    _radiusAnimation = Tween<double>(begin: 42, end: 72).animate(_controller);

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
    canvas.drawCircle(Offset(0.0, 100.0), 72, paint);
    canvas.drawCircle(Offset(0.0, 100.0), radius, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
