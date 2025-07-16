import 'package:checklist/screens/form_view_screen.dart';
import 'package:checklist/widgets/filled_form_card.dart';
import 'package:flutter/material.dart';
import '../models/file_data.dart';
import '../services/smb_service.dart';

class FilledFormOpenScreen extends StatefulWidget {
  final String formType;

  const FilledFormOpenScreen({super.key, required this.formType});

  @override
  State<FilledFormOpenScreen> createState() => _FilledFormOpenScreenState();
}

class _FilledFormOpenScreenState extends State<FilledFormOpenScreen> {
  List<FileData> forms = [];
  List<FileData> filteredForms = [];
  bool isLoading = true;
  String? error;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadFiles();
    _searchController.addListener(_filterForms);
  }

  Future<void> _loadFiles() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final smbService = SmbService();
      final loadedForms = await smbService.getFilledForms(widget.formType);

      setState(() {
        forms = loadedForms;
        filteredForms = loadedForms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Błąd podczas wczytywania plików: $e';
        isLoading = false;
      });
    }
  }

  void _filterForms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredForms = forms.where((form) =>
          form.getFilenameString().toLowerCase().contains(query)
      ).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        filteredForms = forms;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Szukaj formularzy...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : Text('Wybierz ${widget.formType} do podglądu'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            iconSize: 34,
            tooltip: isSearching ? 'Zamknij wyszukiwanie' : 'Szukaj',
            onPressed: _toggleSearch,
          ),
          SizedBox(width: 14),
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 34,
            tooltip: 'Odśwież',
            onPressed: _loadFiles,
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!),
            ElevatedButton(
              onPressed: _loadFiles,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredForms.length,
      itemBuilder: (context, index) {
        final file = filteredForms[index];
        return FilledFormCard(
          fileSplitName: file.getFilenameString(),
          onOpen: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormViewScreen(formFile: file),
              ),
            );
          },
        );
      },
    );
  }
}
