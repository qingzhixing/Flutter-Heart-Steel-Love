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

  void _onCharged() async {
    if (_heartSteelCharge < 3) {
      setState(() {
        _heartSteelCharge++;
      });
      // SFX
      var player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      var cache = AudioCache(prefix: 'assets/SFX/');
      Future<Uri> sfxUri;

      try {
        // 第三层的充能特效不同
        if (_heartSteelCharge == 3) {
          var sfxId = Random().nextInt(3) + 1;
          sfxUri = cache.load('Heartsteel_3rd_stack_SFX_$sfxId.mp3');
        } else {
          var sfxId = Random().nextInt(4) + 1;
          sfxUri = cache.load('Heartsteel_stack_SFX_$sfxId.mp3');
          // 此时还能继续充能
          chargeTimer = Timer(const Duration(milliseconds: 1000), _onCharged);
        }
      } catch (e) {
        debugPrint("Error loading audio file: $e");
        return;
      }

      await sfxUri.then((uri) {
        player.setSource(UrlSource(uri.path));
      });

      await player.setVolume(0.5);
      await player.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    chargeTimer = Timer(const Duration(milliseconds: 1000), _onCharged);
  }

  void _onHeartSteelPressed() async {
    if (_heartSteelCharge < 3) {
      return;
    }

    setState(() {
      _heartSteelStack += Random().nextInt(45) + 20;
      _heartSteelCharge = 0;
    });

    // 三选一播放文件
    var sfxId = Random().nextInt(3) + 1;
    var player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    var cache = AudioCache(prefix: 'assets/SFX/');
    Future<Uri> sfxUri;
    try {
      sfxUri = cache.load('Heartsteel_trigger_SFX_$sfxId.mp3');
    } catch (e) {
      debugPrint("Error loading audio file: $e");
      return;
    }
    await sfxUri.then((uri) {
      player.setSource(UrlSource(uri.path));
    });
    await player.setVolume(0.3);
    await player.resume();

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
                '我要叠钢',
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
                    child: Stack(
                      children: [
                        Positioned(
                          right: 20,
                          bottom: 10,
                          child: Text(
                            _heartSteelStack.toString(),
                            style: const TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                  blurRadius: 1,
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                              fontFamily: "Microsoft YaHei",
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: _onHeartSteelPressed,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
