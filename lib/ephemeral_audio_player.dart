import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class EphemeralAudioPlayer {
  static final AudioCache _audioCache = AudioCache(prefix: 'assets/SFX/');
  static final Map<String, Uri> _preloadedSounds = {};

  /// 播放音频并自动释放
  static Future<void> playAndDispose({
    required String assetPath,
    double volume = 1.0,
  }) async {
    final player = AudioPlayer();

    // 平台特定配置
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await player.setAudioContext(AudioContext(
          android: AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ));
      }
    }

    try {
      // 如果有预加载的音效，使用预加载的URI
      if (_preloadedSounds[assetPath] == null) {
        _preloadedSounds[assetPath] = await _audioCache.load(assetPath);
      }
      final uri = _preloadedSounds[assetPath];
      final source = uri != null ? UrlSource(uri.path) : AssetSource(assetPath);

      // 设置播放完成回调
      player.onPlayerComplete.listen((_) async {
        await player.dispose();
        debugPrint('播放器已释放');
      });

      // 开始播放
      await player.setVolume(volume);
      await player.play(source);
    } catch (e) {
      await player.dispose(); // 发生错误时立即释放
      debugPrint('播放失败: $e');
    }
  }
}
