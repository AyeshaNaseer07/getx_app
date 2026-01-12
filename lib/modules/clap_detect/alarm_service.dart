import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AlarmService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> init() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(1.0);
    debugPrint('✅ Alarm service initialized');
  }

  Future<void> playAlarm() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;

      // Play your custom fire alarm from assets
      await _audioPlayer.play(AssetSource('alarms/fire_alarm.mp3'));

      debugPrint('🚨 Fire alarm playing!');
    } catch (e) {
      debugPrint('❌ Error playing alarm: $e');
      _isPlaying = false;
    }
  }

  Future<void> stopAlarm() async {
    if (!_isPlaying) return;

    await _audioPlayer.stop();
    _isPlaying = false;
    debugPrint('✅ Alarm stopped');
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
