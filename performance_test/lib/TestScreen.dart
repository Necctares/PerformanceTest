import 'dart:math';

import 'package:flutter/material.dart';
import 'package:performance_test/FileWriter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late bool testExecuting;
  late String testPhase;
  late String savedFileDir;

  @override
  void initState() {
    super.initState();
    testExecuting = true;
    savedFileDir = '';
    testPhase = 'Initializing...';
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTests(context));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Performance Test Execution'),
          elevation: 4,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _mainTestWidget()),
      ),
    );
  }

  List<Widget> _mainTestWidget() {
    if (testExecuting) {
      return <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Test stage: $testPhase')])
      ];
    } else {
      return <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          const Text('Test Finished!'),
          Text('File saved at: $savedFileDir')
        ])
      ];
    }
  }

  _startTests(BuildContext context) {
    _sortingTest();
  }

  _sortingTest() {
    FileWriter fw = FileWriter();
    fw.getFilePath('TestResult.txt').then((value) => {savedFileDir = value});

    var vetor10 = List.generate(10, (_) => Random().nextInt(1000));
    var vetor100 = List.generate(100, (_) => Random().nextInt(1000));
    var vetor1000 = List.generate(1000, (_) => Random().nextInt(1000));
    var vetor10000 = List.generate(10000, (_) => Random().nextInt(1000));
    var vetor100000 = List.generate(100000, (_) => Random().nextInt(1000));
    Stopwatch sw = Stopwatch();
    sw.start();
    vetor10.sort();
    sw.stop();

    fw.writeToFile('$testPhase\n', 'TestResult.txt');
    setState(() {});
  }
}
