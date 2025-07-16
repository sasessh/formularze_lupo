import 'package:checklist/screens/filled_form_open_screen.dart';
import 'package:checklist/widgets/form_type_card.dart';
import 'package:flutter/material.dart';
import '../services/smb_service.dart';

class FilledFormTypeScreen extends StatefulWidget {
  const FilledFormTypeScreen({super.key});

  @override
  State<FilledFormTypeScreen> createState() => _FilledFormOpenScreenState();
}

class _FilledFormOpenScreenState extends State<FilledFormTypeScreen> {
  List<String> formTypes = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    _loadForms();
  }

  Future<void> _loadForms() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final smbService = SmbService();
      final loadedFolders = await smbService.getFormsTypes();

      setState(() {
        formTypes = loadedFolders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Błąd podczas wczytywania plików: $e';
        isLoading = false;
      });
    }
  }

  void _openFormType(String formType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilledFormOpenScreen(formType: formType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz typ formularza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 34,
            tooltip: 'Odśwież',
            onPressed: _loadForms,
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

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: formTypes.length,
      itemBuilder: (context, index) {
        final type = formTypes[index];
        return FormTypeCard(
          form: type,
          onTap: () {
            _openFormType(type);
          },
        );
      },
    );
  }
}
