import 'package:flutter/material.dart';
import 'package:performance_test/MLTest.dart';
import 'package:performance_test/TestScreen.dart';
import 'package:performance_test/WriteTest.dart';

import 'DeviceInfo.dart';

void main() {
  runApp(const MyApp());
  //runApp(const MLTest());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Performance Test'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: mainButtonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeviceInfo()),
                    );
                  },
                  child: const Text('Get Device Info'),
                )),
            Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: mainButtonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TestScreen()),
                    );
                  },
                  child: const Text('Start test'),
                ))
          ],
        ),
      ),
    );
  }

  ButtonStyle mainButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
    padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
    backgroundColor: MaterialStateProperty.all(Colors.blue),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    textStyle: MaterialStateProperty.all(const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    )),
  );
}
