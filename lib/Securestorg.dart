import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securestorg {
  static const storage = FlutterSecureStorage();

  static Future<void> write(String data) async {
    await storage.write(key: 'key', value: data);
  }
  static Future<String?> read() async {
    return await storage.read(key: 'key');
  }
}
