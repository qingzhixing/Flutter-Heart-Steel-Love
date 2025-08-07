import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

var appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

void heartSteelButtonPressed() async {
  // 三选一播放文件
  var sfxId = Random().nextInt(3) + 1;
  var player = AudioPlayer();
  // Set the release mode to keep the source after playback has completed.
  player.setReleaseMode(ReleaseMode.stop);
  await player.setSource(AssetSource('SFX/Heartsteel_trigger_SFX_$sfxId.mp3'));

  await player.resume();
}

void main() {
  runApp(
    MaterialApp(
      title: "庞然吞噬 之 我要叠钢钢钢钢",
      home: const MainPage(),
      theme: appThemeData,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                '庞然吞噬 之 我要 叠！钢！',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Microsoft YaHei",
                ),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.heart_broken,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 50,
            bottom: 50,
            right: 50,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Ink(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/icon/HeartSteel.jpg'),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: heartSteelButtonPressed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
