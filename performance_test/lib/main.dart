import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:performance_test/TestScreen.dart';

import 'DeviceInfo.dart';
import 'FileWriter.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Performance Test';
  String _dirPath = '';

  @override
  void initState() {
    super.initState();
    _loadPath();
  }

  void _loadPath() async {
    _dirPath = (await getApplicationDocumentsDirectory()).path;
    setState(() {});
  }

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
                )),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Directory Path: $_dirPath'))
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
