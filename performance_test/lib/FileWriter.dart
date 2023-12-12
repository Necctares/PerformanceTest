import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';

class FileWriter {

  Future<Directory> getApplicationDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDirectory();
    final path = '${directory.path}/$fileName';
    return path;
  }

  Future<void> writeToFile(String data, String fileName) async {
    final path = await getFilePath(fileName);
    final file = File(path);
    await file.writeAsString(data);
  }

  Future<void> appendToFile(String data, String fileName) async {
    final path = await getFilePath(fileName);
    final file = File(path);
    await file.writeAsString(data, mode: FileMode.append);
  }

  Future<String> readFile(String fileName) async {
    final path = await getFilePath(fileName);
    final file = File(path);
    final contents = await file.readAsString();
    return contents;
  }

  Future<bool> fileExists(String fileName) async {
    final path = await getFilePath(fileName);
    final file = File(path);
    return await file.exists();
  }

}