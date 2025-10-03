import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:heart_steel/ephemeral_audio_player.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  final int maxHeartSteelCharge = 3;

  // 狂暴模式充能时间
  final int rageModeChargeTime = 200;
  // 普通模式充能时间
  final int normalModeChargeTime = 1000;

  int chargeTime_ms = 1000;
  // 狂暴模式开关状态
  bool _isRageMode = false;
  // 无冷却模式开关状态
  bool _isNoCooldown = false;

  void _onCharged() async {
    if (_heartSteelCharge >= maxHeartSteelCharge || _isNoCooldown) return;

    setState(() {
      _heartSteelCharge++;
    });
    // SFX

    // 最后一层的充能特效不同
    if (_heartSteelCharge == maxHeartSteelCharge) {
      var sfxId = Random().nextInt(3) + 1;
      EphemeralAudioPlayer.playAndDispose(
          assetPath: 'Heartsteel_3rd_stack_SFX_$sfxId.mp3');
    } else {
      var sfxId = Random().nextInt(4) + 1;
      EphemeralAudioPlayer.playAndDispose(
          assetPath: 'Heartsteel_stack_SFX_$sfxId.mp3');
      // 此时还能继续充能
      chargeTimer = Timer(Duration(milliseconds: chargeTime_ms), _onCharged);
    }
  }

  // 处理狂暴模式开关变化
  void _onRageModeChanged(bool value) {
    setState(() {
      _isRageMode = value;
      // 取消当前的充能计时器
      chargeTimer.cancel();
      // 根据狂暴模式状态设置充能时间
      chargeTime_ms = value ? rageModeChargeTime : normalModeChargeTime;
    });

    // 如果不是无冷却模式，重新启动充能计时器
    if (!_isNoCooldown && _heartSteelCharge < maxHeartSteelCharge) {
      chargeTimer = Timer(Duration(milliseconds: chargeTime_ms), _onCharged);
    }
  }

  // 处理无冷却模式开关变化
  void _onNoCooldownChanged(bool value) {
    setState(() {
      _isNoCooldown = value;
      // 取消当前的充能计时器
      chargeTimer.cancel();
    });

    // 如果开启无冷却模式，立即将充能充满
    if (value) {
      setState(() {
        _heartSteelCharge = maxHeartSteelCharge;
      });
    } else {
      // 如果关闭无冷却模式，重新开始充能
      chargeTimer = Timer(Duration(milliseconds: chargeTime_ms), _onCharged);
    }
  }

  @override
  void initState() {
    super.initState();
    chargeTimer = Timer(Duration(milliseconds: chargeTime_ms), _onCharged);
  }

  void _onHeartSteelPressed() async {
    if (!_isNoCooldown && _heartSteelCharge < maxHeartSteelCharge) {
      return;
    }

    setState(() {
      _heartSteelStack += Random().nextInt(45) + 20;
      // 在无冷却模式下，充能始终保持满格
      if (!_isNoCooldown) {
        _heartSteelCharge = 0;
      }
    });

    // 三选一播放文件
    var sfxId = Random().nextInt(3) + 1;
    EphemeralAudioPlayer.playAndDispose(
        assetPath: 'Heartsteel_trigger_SFX_$sfxId.mp3');

    // 如果不是无冷却模式，恢复充能
    if (!_isNoCooldown) {
      chargeTimer = Timer(Duration(milliseconds: chargeTime_ms), _onCharged);
    }
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
            child: Column(
              spacing: 10,
              children: [
                // 心之钢展示部分
                AspectRatio(
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
                // 设置部分
                // 狂暴模式开关
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      '狂暴模式:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Microsoft YaHei",
                      ),
                    ),
                    Switch(
                      value: _isRageMode,
                      onChanged: _onRageModeChanged,
                      activeThumbColor: Colors.red,
                      inactiveTrackColor: Colors.grey,
                    ),
                    Text(
                      _isRageMode ? '200ms' : '1000ms',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Microsoft YaHei",
                      ),
                    ),
                  ],
                ),
                // 无冷却模式开关
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      '无冷却模式:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Microsoft YaHei",
                      ),
                    ),
                    Switch(
                      value: _isNoCooldown,
                      onChanged: _onNoCooldownChanged,
                      activeThumbColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ],
                ),
                // 署名
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    const Text(
                      '@qingzhixing',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: "Microsoft YaHei",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrlString(
                          "https://github.com/qingzhixing/Flutter-Heart-Steel-Love",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const Text("项目源码: @Github"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
