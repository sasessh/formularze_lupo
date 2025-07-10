import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _hostController = TextEditingController();
  final _domainController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _templatePathController = TextEditingController();
  final _filledPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hostController.text = prefs.getString('smb_host') ?? '';
      _domainController.text = prefs.getString('smb_domain') ?? '';
      _usernameController.text = prefs.getString('smb_username') ?? '';
      _passwordController.text = prefs.getString('smb_password') ?? '';
      _templatePathController.text = prefs.getString('smb_template_path') ?? '';
      _filledPathController.text = prefs.getString('smb_filled_path') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('smb_host', _hostController.text.trim());
    await prefs.setString('smb_domain', _domainController.text.trim());
    await prefs.setString('smb_username', _usernameController.text.trim());
    await prefs.setString('smb_password', _passwordController.text.trim());
    await prefs.setString(
      'smb_template_path',
      _templatePathController.text.trim(),
    );
    await prefs.setString('smb_filled_path', _filledPathController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ustawienia zostały zapisane!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfiguracja urządzenia i SMB')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Divider(),
            const Text(
              'Konfiguracja połączenia SMB',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Adres hosta (host/IP)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Domena (opcjonalnie)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nazwa użytkownika',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Hasło',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _templatePathController,
              decoration: const InputDecoration(
                labelText: 'Ścieżka szablonów',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _filledPathController,
              decoration: const InputDecoration(
                labelText: 'Ścieżka zapisywania formularzy',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
