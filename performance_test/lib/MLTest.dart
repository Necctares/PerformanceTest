import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:performance_test/FileWriter.dart';
import 'package:performance_test/main.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLTest extends StatefulWidget {
  const MLTest({super.key});

  @override
  State<StatefulWidget> createState() => _MLTestState();
}

class _MLTestState extends State<MLTest> {
  FileWriter fw = FileWriter();
  Stopwatch sw = Stopwatch();
  Interpreter? _interpreter;
  List<String> _labels = [];
  List<String> imagePaths = [];
  Map<String, List<dynamic>> results = {};

  @override
  void initState() {
    super.initState();
    fw.writeToFile("Starting Machine Learning Classification Test...\n\n", "MLTest", "txt");
    fw.appendToFile("Model: Mobilenet_v1 Resolução 224 pixels\n\n", "MLTest", "txt");
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Carregar o modelo TensorFlow Lite
      final interpreterOptions = InterpreterOptions();
      if (Platform.isAndroid) {
        interpreterOptions.addDelegate(XNNPackDelegate());
      }
      interpreterOptions.threads = 4;
      _interpreter = await Interpreter.fromAsset(
          'assets/models/mobilenet_v1_1.0_224.tflite',
          options: interpreterOptions);

      // Carregar as etiquetas / rótulos
      final labelsData =
          await rootBundle.loadString('assets/models/classifier_labels.txt');
      _labels = labelsData.split('\n');
    } catch (e) {
      print('Erro ao carregar o modelo: $e');
    }
  }

  Future<void> _classifyImage() async {
    try {
      final Map<String, dynamic> assets =
          jsonDecode(await rootBundle.loadString('AssetManifest.json'));
      imagePaths =
          assets.keys.where((String key) => key.contains('.png')).toList();
      sw.reset();
      sw.start();
      for (var img in imagePaths) {
        var image = await rootBundle.load(img)
          ..buffer.asUint8List();

        var output =
            List.filled(_labels.length, 0).reshape([1, _labels.length]);
        _interpreter!.run(image.buffer, output);

        var getMaxPos = 0;
        var maxValue = output[0];
        for (int i = 1; i < output.length; i++) {
          if (output[i] > maxValue) {
            getMaxPos = i;
            maxValue = output[i];
          }
        }
        var topPrediction = _labels[getMaxPos];
        results[img] = [topPrediction, maxValue];
      }
      sw.stop();
      fw.appendToFile("Time Elapsed to classify ${results.length} : ${sw.elapsedMicroseconds} Microseconds.\n\n", "MLTest", "txt");
      for (var result in results.keys) {
        fw.appendToFile("Image: $result - Predicted: ${results[result]?[0]} - Confidence: ${results[result]?[1]}\n", "MLTest", "txt");
      }
      _endTest();
    } catch (e) {
      print('Erro ao classificar a imagem: $e');
    }
  }

  void _endTest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Performance Test"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Learning Test'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Running ML inferences...",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
