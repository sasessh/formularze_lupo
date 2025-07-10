// Przykładowa konfiguracja aplikacji
// Zmienić nazwę pliku na app_config.dart

class AppConfig {
  // hasło do ustawień, wymagane do zmiany konfiguracji SMB
  static const String settingsPassword = '';
  
  static const Map<String, String> defaultSmbConfig = {
    // predefiniowana konfiguracja SMB
    'smb_host': '',
    'smb_domain': '', 
    'smb_username': '',
    'smb_password': '',
    'smb_template_path': '',
    'smb_filled_path': '',
  };
}