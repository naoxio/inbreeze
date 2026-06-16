import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  final Map<String, AudioPlayer> _players = {};
  final AudioContext _soundEffectContext =
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build();

  Future<void> initialize() async {}

  String _assetPathForPlatform(String assetPath) {
    if (defaultTargetPlatform == TargetPlatform.android &&
        assetPath.endsWith('.m4a')) {
      return assetPath.replaceFirst('.m4a', '.ogg');
    }
    return assetPath;
  }

  Future<AudioPlayer> _getPlayer(String playerId) async {
    var player = _players[playerId];
    if (player == null) {
      player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setAudioContext(_soundEffectContext);
      _players[playerId] = player;
    }
    return player;
  }

  Future<void> preload(String assetPath, String playerId) async {
    try {
      final player = await _getPlayer(playerId);
      final resolvedAssetPath = _assetPathForPlatform(assetPath);
      await player.setSource(
          AssetSource(resolvedAssetPath.replaceFirst('assets/', '')));
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
      final player = await _getPlayer(playerId);
      final resolvedAssetPath = _assetPathForPlatform(assetPath);
      await player.stop();
      await player.play(
        AssetSource(resolvedAssetPath.replaceFirst('assets/', '')),
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
