import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/config_model.dart';
import '../config/app_config.dart';

class ConfigService {
  static Future<Map<String, String>?> getSmbConfig() async {
    try {
      final serverConfig = await _fetchConfigFromServer();
      if (serverConfig != null) {
        return serverConfig.toSmbConfig();
      }
    } catch (e) {
      print('Błąd podczas pobierania konfiguracji z serwera: $e');
    }

    return null;
  }

  static Future<ConfigModel?> _fetchConfigFromServer() async {
    try {
      final response = await http
          .get(
            Uri.parse(AppConfig.configUrl),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('smb')) {
          return ConfigModel.fromJson(jsonData['smb']);
        } else {
          return ConfigModel.fromJson(jsonData);
        }
      } else {
        print('Błąd HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Błąd połączenia z serwerem: $e');
      return null;
    }
  }
}
