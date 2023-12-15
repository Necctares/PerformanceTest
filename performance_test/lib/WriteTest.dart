import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:performance_test/FileWriter.dart';
import 'package:performance_test/MLTest.dart';
import 'package:performance_test/main.dart';

class WriteTest extends StatelessWidget {
  const WriteTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Text File Reader',
      home: WriteTestPage(),
    );
  }
}

class WriteTestPage extends StatefulWidget {
  const WriteTestPage({super.key});

  @override
  _WriteTestPageState createState() => _WriteTestPageState();
}

class _WriteTestPageState extends State<WriteTestPage> {
  final words_per_line = 20;
  List<int> fileLengths = [100, 1000, 5000, 10000, 15000];
  FileWriter fw = FileWriter();
  var millisecondsSE = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    fw.writeToFile("Starting Write test...\n\n", "WriteTest", "txt");
    _generateTextAndWriteToFile();
  }

  Future<void> _generateTextAndWriteToFile() async {
    var timings = [];
    try {
      Stopwatch sw = Stopwatch();
      for (int i = 0; i < fileLengths.length; i++) {
        String text = generateRandomText(fileLengths[i]);
        File file = File(
            '${(await fw.getApplicationDirectory()).path}/PerformanceTestApp/generated_text_${fileLengths[i]}_$millisecondsSE.txt');
        sw.reset();
        sw.start();
        await file.writeAsString(text);
        sw.stop();
        timings.add(sw.elapsedMicroseconds);
      }
      var index = 0;
      for (var time in timings) {
        await fw.appendToFile(
            "Time elapsed to write ${fileLengths[index]} x $words_per_line : $time Microseconds.\n",
            "WriteTest",
            "txt");
        index += 1;
      }
      _readFileAndMeasureTime();
    } catch (e) {
      print(e);
    }
  }

  String generateRandomText(int numberOfLines) {
    String result = '';
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789 ';

    for (var j = 0; j < numberOfLines; j++) {
      for (var i = 0; i < words_per_line; i++) {
        result += chars[random.nextInt(chars.length)];
      }
      result += '\n';
    }
    return result;
  }

  Future<void> _readFileAndMeasureTime() async {
    try {
      var timings = [];
      Stopwatch sw = Stopwatch();
      fw.appendToFile("\nStarting Read Test...\n\n", "WriteTest", "txt");
      for (int i = 0; i < fileLengths.length; i++) {
        File file = File(
            '${(await fw.getApplicationDirectory()).path}/PerformanceTestApp/generated_text_${fileLengths[i]}_$millisecondsSE.txt');
        sw.reset();
        sw.start();
        String contents = await file.readAsString();
        sw.stop();
        timings.add(sw.elapsedMicroseconds);
      }
      var index = 0;
      for (var time in timings) {
        await fw.appendToFile(
            "Time elapsed to read ${fileLengths[index]} x $words_per_line : $time Microseconds.\n",
            "WriteTest",
            "txt");
        index += 1;
      }
    } catch (e) {
      print(e);
    }
    _endTest();
  }

  void _endTest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text File Reader & Writer'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Running Text Write & Read tests...",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
