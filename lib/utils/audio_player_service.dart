import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class AudioPlayerService {
  final Map<String, AudioPlayer> _players = {};

  Future<void> initialize() async {}

  Future<void> preload(String assetPath, String playerId) async {
    try {
      var player = _players[playerId];
      if (player == null) {
        player = AudioPlayer();
        await player.setReleaseMode(ReleaseMode.stop);
        _players[playerId] = player;
      }
      await player
          .setSource(AssetSource(assetPath.replaceFirst('assets/', '')));
      await player.setVolume(0);
    } catch (e) {
      print('Error preloading audio: $e');
    }
  }

  Future<void> play(String assetPath, double volume, String playerId) async {
    if (volume == 0) {
      return;
    }

    try {
      var player = _players[playerId];
      if (player == null) {
        player = AudioPlayer();
        await player.setReleaseMode(ReleaseMode.stop);
        _players[playerId] = player;
      }
      await player.play(
        AssetSource(assetPath.replaceFirst('assets/', '')),
        volume: volume / 100,
      );
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stop(String playerId) async {
    try {
      var player = _players[playerId];
      if (player != null) {
        await player.stop();
      }
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  void disposePlayer(String playerId) {
    try {
      var player = _players[playerId];
      if (player != null) {
        player.dispose();
        _players.remove(playerId);
      }
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }

  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
