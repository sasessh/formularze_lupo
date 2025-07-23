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

  Future<List<FileData>> getEmptyFormsFromDirectory() async {
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
      forms.sort((a, b) => (a.form).compareTo(b.form));
      return forms;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getFormsTypes() async {
    await _loadConfig();

    try {
      final connect = await SmbConnect.connectAuth(
        host: _host!,
        domain: _domain!,
        username: _username!,
        password: _password!,
      );

      SmbFile folder = await connect.file(_filledPath!);
      List<SmbFile> files = await connect.listFiles(folder);
      List<String> folderNames = [];
      final now = DateTime.now();

      for (var file in files) {
        if (file.isDirectory() &&
            (file.name == now.year.toString() ||
                file.name == (now.year - 1).toString())) {
          SmbFile subFolder = await connect.file(file.path);
          List<SmbFile> subFiles = await connect.listFiles(subFolder);
          for (var subFile in subFiles) {
            if (subFile.isDirectory() && !folderNames.contains(subFile.name)) {
              folderNames.add(subFile.name);
            }
          }
        }
      }

      await connect.close();
      folderNames.sort((a, b) => a.compareTo(b));
      return folderNames;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FileData>> getFilledForms(String formType) async {
    await _loadConfig();

    try {
      final connect = await SmbConnect.connectAuth(
        host: _host!,
        domain: _domain!,
        username: _username!,
        password: _password!,
      );

      final now = DateTime.now();
      final currentYear = now.year.toString();
      final previousYear = (now.year - 1).toString();
      List<FileData> forms = [];

      try {
        SmbFile folder = await connect.file(
          '$_filledPath/$currentYear/$formType',
        );
        List<SmbFile> files = await connect.listFiles(folder);

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
      } catch (e) {
        // print('Error loading files for current year ($currentYear): $e');
      }

      try {
        SmbFile folder = await connect.file(
          '$_filledPath/$previousYear/$formType',
        );
        List<SmbFile> files = await connect.listFiles(folder);

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
      } catch (e) {
        // print('Error loading files from previous year ($previousYear): $e');
      }

      await connect.close();
      forms.sort((a, b) => (b.fileDate ?? '').compareTo(a.fileDate ?? ''));
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
    } catch (e) {
      yearFolder = await connect.file(yearFolderPath);
    }

    final formFolderPath = '${yearFolder.path}/$formName';
    SmbFile? formFolder;

    try {
      formFolder = await connect.createFolder(formFolderPath);
    } catch (e) {
      formFolder = await connect.file(formFolderPath);
    }

    final SmbFile file = await connect.file('${formFolder.path}/$fileName');

    IOSink writer = await connect.openWrite(file);
    writer.add(utf8.encode(content));
    await writer.flush();
    await writer.close();
  }
}
