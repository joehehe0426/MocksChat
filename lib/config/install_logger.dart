
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
// Demo/test: Run this main() to log a test entry
Future<void> main() async {
  await InstallLogger.log('Test log entry from install_logger.dart main()');
  print('Test log entry written.');
}

class InstallLogger {
  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/install_log.txt');
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    return file;
  }

  static Future<void> log(String message) async {
    final file = await _getLogFile();
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append, flush: true);
  }

  static Future<String> readLog() async {
    final file = await _getLogFile();
    return await file.readAsString();
  }
}
