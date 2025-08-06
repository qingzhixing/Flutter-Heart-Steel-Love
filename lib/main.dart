import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: "庞然吞噬之我要叠钢钢钢钢",
      home: const MainPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
          child: Text('庞然吞噬之我要叠钢钢钢钢'),
        ),
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
