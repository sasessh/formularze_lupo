import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ConfigService {
  static Future<Map<String, String>> getSmbConfig() async {
    final prefs = await SharedPreferences.getInstance();
    
    final hasConfig = prefs.getString('smb_host') != null;
    
    if (!hasConfig) {
      await _saveDefaultConfig(prefs);
    }
    
    return {
      'smb_host': prefs.getString('smb_host') ?? AppConfig.defaultSmbConfig['smb_host']!,
      'smb_domain': prefs.getString('smb_domain') ?? AppConfig.defaultSmbConfig['smb_domain']!,
      'smb_username': prefs.getString('smb_username') ?? AppConfig.defaultSmbConfig['smb_username']!,
      'smb_password': prefs.getString('smb_password') ?? AppConfig.defaultSmbConfig['smb_password']!,
      'smb_template_path': prefs.getString('smb_template_path') ?? AppConfig.defaultSmbConfig['smb_template_path']!,
      'smb_filled_path': prefs.getString('smb_filled_path') ?? AppConfig.defaultSmbConfig['smb_filled_path']!,
    };
  }
  
  static Future<void> _saveDefaultConfig(SharedPreferences prefs) async {
    for (final entry in AppConfig.defaultSmbConfig.entries) {
      await prefs.setString(entry.key, entry.value);
    }
  }
}