import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedBreathingCircle extends StatefulWidget {
  final int volume;
  final Duration tempoDuration; 
  final String? innerText; 
  final Function()? controlCallback;

  AnimatedBreathingCircle({
    required this.volume,
    required this.tempoDuration,
    this.innerText,
    this.controlCallback,
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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.tempoDuration, // Use the tempo parameter
    );
    
    _radiusAnimation = Tween<double>(begin: 40, end: 72).animate(_controller);

    _audioPlayer = AudioPlayer();

    _controller.addStatusListener((status) {
      Duration newDuration = widget.tempoDuration;
      if (_controller.duration != newDuration && _controller.status == AnimationStatus.forward) {
        _controller.stop();
        _controller.duration = newDuration;
        _controller.reset();
        _controller.repeat(reverse: true);
      }
  
      if (status == AnimationStatus.forward) {
        _playAudio('sounds/breath-in.ogg');
      } else if (status == AnimationStatus.reverse) {
        _playAudio('sounds/breath-out.ogg');
      }
    });
  }
  @override
  
  void didUpdateWidget(AnimatedBreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    
    if (widget.controlCallback != null) {
      String control = widget.controlCallback!();
      print(_controller.status);
      switch (control) {
        case 'repeat':
          _controller.repeat(reverse: true);
          break;
        case 'forward':
          if (_controller.status != AnimationStatus.forward) {
            _controller.forward();
          }
          break;
        case 'reverse':
          if (_controller.status != AnimationStatus.reverse) {
            _controller.reverse();
          }
          break;
        case 'stop':
          _controller.stop();
          break;
        case 'reset':
          _controller.reset();
          _audioPlayer.dispose();

          if (_controller.status == AnimationStatus.dismissed) {
            _controller.forward();
          }
          break;
      }
    }

  }

  Future<void> _playAudio(String assetPath) async {
    if (_isDisposed || widget.volume == 0) return; 

    try {
      // Check if _audioPlayer has been disposed. If yes, create a new instance.
      if (_audioPlayer.state == PlayerState.disposed) {
        _audioPlayer = AudioPlayer();
      }
      if (_audioPlayer.state == PlayerState.playing) await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
      await _audioPlayer.setVolume(widget.volume / 100); 
      await _audioPlayer.resume();
    } catch (e) {
        print("Error playing audio: $e");
    }
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
        painter: BreathingCircle(_radiusAnimation, innerText: widget.innerText),
      ),
    );
  }
}

class BreathingCircle extends CustomPainter {
  final Animation<double> _animation;
  final String? innerText;

  BreathingCircle(this._animation, {this.innerText}) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.teal;
    var paint2 = Paint();
    paint2.color = Colors.tealAccent;

    double radius = _animation.value;
    canvas.drawCircle(Offset(0.0, 100.0), 72, paint);
    canvas.drawCircle(Offset(0.0, 100.0), radius, paint2);
    
    String? displayText = innerText;

    // Try to parse the innerText as an integer
    int? numberValue = int.tryParse(innerText ?? '');

    // If the parsed value is a number and is less than 0, update the displayText to its absolute value
    if (numberValue != null && numberValue < 0) {
      displayText = numberValue.abs().toString();
    }

    if (displayText != null) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: displayText, style: TextStyle(color: Colors.black, fontSize: 32.0)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 100.0 - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant BreathingCircle oldDelegate) {
    return oldDelegate.innerText != innerText;
  }
}
