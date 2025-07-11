import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:smb_connect/smb_connect.dart';
import '../models/file_data.dart';
import 'config_service.dart';

class SmbService {
  String? _host;
  String? _domain;
  String? _username;
  String? _password;
  String? _templatePath;
  String? _filledPath;

  SmbService();

  Future<void> _loadConfig() async {
    final config = await ConfigService.getSmbConfig();

    if (config == null) {
      throw Exception('Nie można pobrać konfiguracji z serwera');
    }

    _host = config['smb_host'];
    _domain = config['smb_domain'];
    _username = config['smb_username'];
    _password = config['smb_password'];
    _templatePath = config['smb_template_path'];
    _filledPath = config['smb_filled_path'];
  }

  Future<List<FileData>> getFormsFromDirectory() async {
    await _loadConfig();

    try {
      final connect = await SmbConnect.connectAuth(
        host: _host!,
        domain: _domain!,
        username: _username!,
        password: _password!,
      );

      SmbFile folder = await connect.file(_templatePath!);

      List<SmbFile> files = await connect.listFiles(folder);
      List<FileData> forms = [];

      for (var file in files) {
        if (file.name.endsWith('.json')) {
          SmbFile jsonFile = await connect.file(file.path);
          Stream<Uint8List> reader = await connect.openRead(jsonFile);
          List<int> fileBytes = [];

          await for (var chunk in reader) {
            fileBytes.addAll(chunk);
          }

          final jsonString = utf8.decode(fileBytes);
          final jsonData = json.decode(jsonString) as Map<String, dynamic>;
          forms.add(FileData.fromJson(jsonData));
        }
      }

      await connect.close();
      return forms;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveFileToDirectoryWithSubfolders(
    String fileName,
    String content,
    String formName,
  ) async {
    await _loadConfig();

    final connect = await SmbConnect.connectAuth(
      host: _host!,
      domain: _domain!,
      username: _username!,
      password: _password!,
    );

    final SmbFile mainFolder = await connect.file(_filledPath!);

    final currentYear = DateTime.now().year.toString();
    final yearFolderPath = '${mainFolder.path}/$currentYear';

    SmbFile? yearFolder;
    try {
      yearFolder = await connect.createFolder(yearFolderPath);
      // print('Created folder for year $currentYear.');
    } catch (e) {
      yearFolder = await connect.file(yearFolderPath);
      // print('Folder for year $currentYear already exists.');
    }

    final formFolderPath = '${yearFolder.path}/$formName';
    SmbFile? formFolder;

    try {
      formFolder = await connect.createFolder(formFolderPath);
      // print('Created folder for form $formName.');
    } catch (e) {
      formFolder = await connect.file(formFolderPath);
      // print('Folder for form $formName already exists.');
    }

    final SmbFile file = await connect.file('${formFolder.path}/$fileName');

    IOSink writer = await connect.openWrite(file);
    writer.add(utf8.encode(content));
    await writer.flush();
    await writer.close();
  }
}
