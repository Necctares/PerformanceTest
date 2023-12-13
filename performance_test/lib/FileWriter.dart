import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';

class FileWriter {
  final DateTime date = DateTime.now();

  Future<Directory> getApplicationDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<String> getFilePath(String fileName, String extension) async {
    final directory = await getApplicationDirectory();
    final path = '${directory.path}/PerformanceTestApp/${fileName}_${date.year}${date.month}${date.day}_${date.millisecondsSinceEpoch}.$extension';
    return path;
  }

  Future<void> writeToFile(String data, String fileName, String extension) async {
    final path = await getFilePath(fileName, extension);
    final file = File(path);
    await file.writeAsString(data);
  }

  Future<void> appendToFile(String data, String fileName, String extension) async {
    final path = await getFilePath(fileName, extension);
    final file = File(path);
    await file.writeAsString(data, mode: FileMode.append);
  }

  Future<String> readFile(String fileName, String extension) async {
    final path = await getFilePath(fileName, extension);
    final file = File(path);
    final contents = await file.readAsString();
    return contents;
  }

  Future<bool> fileExists(String fileName, String extension) async {
    final path = await getFilePath(fileName, extension);
    final file = File(path);
    return await file.exists();
  }

}