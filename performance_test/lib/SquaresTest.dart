import 'dart:async';
import 'package:performance_test/FileWriter.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:performance_test/main.dart';

class SquaresTest extends StatelessWidget {
  const SquaresTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moving Squares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovingSquaresScreen(),
    );
  }
}

class MovingSquaresScreen extends StatefulWidget {
  const MovingSquaresScreen({super.key});

  @override
  _MovingSquaresScreenState createState() => _MovingSquaresScreenState();
}

class _MovingSquaresScreenState extends State<MovingSquaresScreen> {
  List<Offset> squares = [];
  List<int> numberOfSquares = [10, 100, 500, 1000, 5000, 10000, 20000];
  late Timer _timer;
  final Random _random = Random();
  final Stopwatch sw = Stopwatch();
  FileWriter fw = FileWriter();
  var seconds = 0;
  var index = 0;
  var lastFPS = 0.00;
  var fps = 0.00;

  @override
  void initState() {
    super.initState();
    fw.appendToFile("\n\nStarting Squares test...\n", "TestResult.txt");
    _startMovingSquares(numberOfSquares[index]);
  }

  void _startMovingSquares(int sqNumbers) {
    squares.clear();
    for (int i = 0; i < sqNumbers; i++) {
      squares.add(Offset(
        _random.nextDouble() * 500,
        _random.nextDouble() * 500,
      ));
    }
    sw.reset();
    sw.start();
    lastFPS = 0;
    fps = 0;
    seconds = 0;
    const duration = Duration(milliseconds: 1); // 2 minutes
    _timer = Timer.periodic(duration, (timer) {
      _moveSquares();
    });
  }

  void _endTest() {
    sw.stop();
    _timer.cancel();
    fw.appendToFile(
        "${numberOfSquares[index]} Squares -- Average FPS: ${lastFPS.toStringAsFixed(2)}\n", "TestResult.txt");
    if (index + 1 < numberOfSquares.length) {
      index += 1;
      _startMovingSquares(numberOfSquares[index]);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyApp()),
      );
    }
  }

  void _moveSquares() {
    const double maxMoveDistance = 20.0;
    if (sw.elapsedMilliseconds > 1000) {
      sw.reset();
      seconds += 1;
      lastFPS = fps / seconds;
      if (seconds >= 30) {
        _endTest();
      }
    }
    for (int i = 0; i < squares.length; i++) {
      double offsetX =
          _random.nextDouble() * maxMoveDistance * 2 - maxMoveDistance;
      double offsetY =
          _random.nextDouble() * maxMoveDistance * 2 - maxMoveDistance;

      setState(() {
        squares[i] = Offset(
          (squares[i].dx + offsetX)
              .clamp(0.0, MediaQuery
              .of(context)
              .size
              .width - 50),
          (squares[i].dy + offsetY)
              .clamp(0.0, MediaQuery
              .of(context)
              .size
              .height - 50),
        );
      });
    }
    fps += 1;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Squares Test:  -- Number of Squares: ${numberOfSquares[index]} -- Time elapsed: $seconds seconds -- Average FPS: ${lastFPS.toStringAsFixed(2)}'),
      ),
      body: Stack(
        children: squares
            .map(
              (offset) =>
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors
                      .primaries[_random.nextInt(Colors.primaries.length)],
                ),
              ),
        )
            .toList(),
      ),
    );
  }
}