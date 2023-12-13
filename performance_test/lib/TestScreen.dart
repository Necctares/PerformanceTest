import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:performance_test/FileWriter.dart';
import 'package:performance_test/SquaresTest.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _sortingTest(context));
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
    return <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text('Test stage: $testPhase'),
        Text('File will be saved at: $savedFileDir')
      ])
    ];
  }

  _sortingTest(BuildContext context) async {
    FileWriter fw = FileWriter();
    var dir = await getApplicationDocumentsDirectory();
    Directory('${dir.path}/PerformanceTestApp').createSync(recursive: true);
    fw.getFilePath('SortingTest', 'txt').then((value) => {
          setState(() {
            savedFileDir = value;
          })
        });

    List<int> vetorLengths = [
      10,
      100,
      1000,
      10000,
      100000,
      1000000,
      10000000,
      100000000
    ];

    var timings = [];
    Stopwatch sw = Stopwatch();
    for (int i = 0; i < vetorLengths.length; i++) {
      var vetor = List.generate(vetorLengths[i], (_) => Random().nextInt(1000));
      sw.reset();
      sw.start();
      vetor.sort();
      sw.stop();
      timings.add(sw.elapsedMicroseconds);
    }

    var results = 'Sorting Results:\n';
    var index = 0;
    for (var time in timings) {
      results += '${vetorLengths[index]} Elements: $time microseconds\n';
      index += 1;
    }
    fw.writeToFile('$testPhase\n', 'SortingTest', 'txt').then((value) => fw
        .appendToFile(results, 'SortingTest', 'txt')
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SquaresTest()),
            )));
  }
}
