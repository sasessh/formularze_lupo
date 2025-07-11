class ConfigModel {
  final String host;
  final String domain;
  final String username;
  final String password;
  final String templatePath;
  final String filledPath;

  ConfigModel({
    required this.host,
    required this.domain,
    required this.username,
    required this.password,
    required this.templatePath,
    required this.filledPath,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      host: json['host'] ?? '',
      domain: json['domain'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      templatePath: json['template_path'] ?? '',
      filledPath: json['filled_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'domain': domain,
      'username': username,
      'password': password,
      'template_path': templatePath,
      'filled_path': filledPath,
    };
  }

  Map<String, String> toSmbConfig() {
    return {
      'smb_host': host,
      'smb_domain': domain,
      'smb_username': username,
      'smb_password': password,
      'smb_template_path': templatePath,
      'smb_filled_path': filledPath,
    };
  }
}
