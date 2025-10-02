import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

var appThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer chargeTimer;
  // 心之钢层数
  int _heartSteelStack = 0;
  // 心之钢充能
  int _heartSteelCharge = 0;

  void _onCharged() {
    if (_heartSteelCharge < 3) {
      setState(() {
        _heartSteelCharge++;
      });
      // SFX
      var player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);

      // 第三层的充能特效不同
      if (_heartSteelCharge == 3) {
        var sfxId = Random().nextInt(3) + 1;
        player
            .setSource(AssetSource('SFX/Heartsteel_3rd_stack_SFX_$sfxId.mp3'));
      } else {
        var sfxId = Random().nextInt(4) + 1;
        player.setSource(AssetSource('SFX/Heartsteel_stack_SFX_$sfxId.mp3'));
        // 此时还能继续充能
        chargeTimer = Timer(const Duration(milliseconds: 1000), _onCharged);
      }

      player.setVolume(0.5);
      player.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    chargeTimer = Timer(const Duration(milliseconds: 1000), _onCharged);
  }

  void _onHeartSteelPressed() {
    if (_heartSteelCharge < 3) {
      return;
    }

    setState(() {
      _heartSteelStack += Random().nextInt(65);
      _heartSteelCharge = 0;
    });

    // 三选一播放文件
    var sfxId = Random().nextInt(3) + 1;
    var player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    player.setSource(AssetSource('SFX/Heartsteel_trigger_SFX_$sfxId.mp3'));
    player.setVolume(0.3);
    player.resume();

    // 恢复充能
    chargeTimer = Timer(const Duration(milliseconds: 1000), _onCharged);
  }

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
                '我要 叠！钢！',
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
                    onTap: _onHeartSteelPressed,
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
