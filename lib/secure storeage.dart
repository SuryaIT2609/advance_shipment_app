import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String key, String secret) async {
    await _storage.write(key: "api_key", value: key);
    await _storage.write(key: "api_secret", value: secret);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: "api_key");
  }

  Future<void> removeKey() async {
    return await _storage.delete(key: "api_key");
  }

  Future<void> removeSecret() async {
    return await _storage.delete(key: "api_secret");
  }

  Future<String?> getApiSecret() async {
    return await _storage.read(key: "api_secret");
  }
}
