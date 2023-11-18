import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

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
  late AudioSession _audioSession;
  bool _isInitialized = false;

  Future<AudioSession> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    ));
    return session;
  }

  @override
  void initState() {
    super.initState();
    
    _audioPlayer = AudioPlayer();
     _controller = AnimationController(
      vsync: this,
      duration: widget.tempoDuration,
    );
    _radiusAnimation = Tween<double>(begin: 40, end: 72).animate(_controller);

    _configureAudioSession().then((session) {
      _audioSession = session;
      _audioSession.interruptionEventStream.listen((event) {
        if (event.begin) {
          if (event.type == AudioInterruptionType.pause || event.type == AudioInterruptionType.unknown) {
            _audioPlayer.pause();
          }
        } else {
          if (event.type != AudioInterruptionType.unknown) {
            _audioPlayer.play();
          }
        }
      });

      _controller.addStatusListener((status) {
        Duration newDuration = widget.tempoDuration;
        if (_controller.duration != newDuration &&
            _controller.status == AnimationStatus.forward) {
          _stopAudio();
          _controller.stop();
          _controller.duration = newDuration;
          _controller.forward();
          _controller.repeat(reverse: true);
        }

        if (status == AnimationStatus.forward) {
          _playAudio('assets/sounds/breath-in.ogg');
        } else if (status == AnimationStatus.reverse) {
          _playAudio('assets/sounds/breath-out.ogg');
        }
      });
      
      setState(() {
        _isInitialized = true;
      });
    }).catchError((error) {
      print('Failed to configure audio session: $error');
    });
  }    

  @override
  void didUpdateWidget(AnimatedCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
  
    if (widget.tempoDuration != oldWidget.tempoDuration) {
      _controller.duration = widget.tempoDuration;
      if (widget.controlCallback != null) {
        String control = widget.controlCallback!();
        if (control == 'reset') {
          _controller.reset();
          _stopAudio();
          _controller.forward();
          _controller.repeat(reverse: true);
        }
      }
    }
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
    await _audioPlayer.stop();
  }

  Future<void> _playAudio(String assetPath) async {
    if (widget.volume == 0) return; 

    final session = await AudioSession.instance;
    if (await session.setActive(true)) {
      try {
        await _audioPlayer.setAsset(assetPath);
        await _audioPlayer.setVolume(widget.volume / 100);
        await _audioPlayer.play();
      } catch (e) {
        print("Error playing audio: $e");
      }
    } else {
      print("Failed to activate audio session");
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
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

    int? numberValue = int.tryParse(innerText ?? '');

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
