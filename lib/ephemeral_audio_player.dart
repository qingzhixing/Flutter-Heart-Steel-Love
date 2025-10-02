import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class EphemeralAudioPlayer {
  static final AudioCache _audioCache = AudioCache(prefix: 'assets/SFX/');

  /// 播放音频并自动释放
  static Future<void> playAndDispose({
    required String assetPath,
    double volume = 1.0,
  }) async {
    final player = AudioPlayer();

    _audioCache.load(assetPath).then((uri) {
      player.setSource(UrlSource(uri.path));
    });

    // 平台特定配置
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await player.setAudioContext(AudioContext(
          android: const AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ));
      }
    }

    try {
      // 设置播放完成回调
      player.onPlayerComplete.listen((_) async {
        await player.dispose();
        debugPrint('播放器已释放');
      });

      // 开始播放
      await player.setVolume(volume);
      await player.play(AssetSource(assetPath));
    } catch (e) {
      await player.dispose(); // 发生错误时立即释放
      debugPrint('播放失败: $e');
    }
  }
}
