import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedCircle extends StatefulWidget {
  final int volume;
  final Duration tempoDuration; 
  final String? innerText; 
  final Function()? controlCallback;

  AnimatedCircle({
    required this.volume,
    required this.tempoDuration,
    this.innerText,
    this.controlCallback,
  });
  
  @override
  AnimatedCircleState createState() => AnimatedCircleState();
}

enum BreathingState { inhale, exhale }

class AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late AudioPlayer _audioPlayer;
  
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
        _stopAudio();
        _controller.stop();
        _controller.duration = newDuration;
        _controller.forward();
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
  
  void didUpdateWidget(AnimatedCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    
    if (widget.controlCallback != null) {
      String currentStatus = _controller.status.toString().split('.').last;
      String control = widget.controlCallback!();
      if (control != currentStatus) {
        switch (control) {
          case 'repeat':
            if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.reverse) break;
            _controller.forward();
            _controller.repeat(reverse: true);
            break;
          case 'forward':
            _controller.forward();
            break;
          case 'reverse':
            _controller.reverse();
            break;
          case 'stop':
            _stopAudio();
            _controller.stop();
            break;
          case 'reset':
            _stopAudio();
            _controller.stop();
            _controller.forward();
            _controller.repeat(reverse: true);
            break;
        }
      }
    }

  }
  void _stopAudio() async {
    if (_audioPlayer.state == PlayerState.playing || _audioPlayer.state == PlayerState.completed) {
      await _audioPlayer.release();
    }
  }

  Future<void> _playAudio(String assetPath) async {
    if (widget.volume == 0) return; 

    try {
      // Check if _audioPlayer has been disposed. If yes, create a new instance.
      if (_audioPlayer.state == PlayerState.disposed) {
        _audioPlayer = AudioPlayer();
      }
      
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.release();
      } 
      await _audioPlayer.play(AssetSource(assetPath));
      await _audioPlayer.setVolume(widget.volume / 100); 
      await _audioPlayer.resume();
    } catch (e) {
        print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_audioPlayer.state != PlayerState.disposed) {
      _audioPlayer.dispose();
    }
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
