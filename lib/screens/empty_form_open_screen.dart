import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:checklist/screens/form_fill_screen.dart';
import '../widgets/empty_form_card.dart';
import '../services/smb_service.dart';
import '../models/file_data.dart';

class EmptyFormOpenScreen extends StatefulWidget {
  const EmptyFormOpenScreen({super.key});

  @override
  State<EmptyFormOpenScreen> createState() => _FileOpenScreenState();
}

class _FileOpenScreenState extends State<EmptyFormOpenScreen> {
  List<FileData> files = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final smbService = SmbService();
      final loadedFiles = await smbService.getEmptyFormsFromDirectory();

      setState(() {
        files = loadedFiles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Błąd podczas wczytywania plików: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wybierz formularz do wypełniania'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              iconSize: 34,
              tooltip: 'Odśwież listę formularzy',
              onPressed: _loadFiles,
            ),
            SizedBox(width: 24),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadFiles,
                      child: const Text('Spróbuj ponownie'),
                    ),
                  ],
                ),
              );
            }

            if (files.isEmpty) {
              return const Center(child: Text('Brak dostępnych formularzy'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return EmptyFormCard(
                  form: file.form,
                  title: file.title,
                  onOpen: () {
                    final uuid = Uuid();
                    final localId = uuid.v4();
                    final fileWithId = file.copyWith(localId: localId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormFillScreen(fileData: fileWithId),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
