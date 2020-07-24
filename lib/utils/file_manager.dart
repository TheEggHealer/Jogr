import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  static const String fileName = 'run.log';

  static Future<void> write(String log) async {
    final file = await _getTempLogFile();
    await file.writeAsString(log, mode: FileMode.append);
  }

  static Future<String> read() async {
    final file = await _getTempLogFile();
    return file.readAsString();
  }

  static Future<File> _getTempLogFile() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }

  static Future<void> clear() async {
    final file = await _getTempLogFile();
    await file.writeAsString('');
  }
}