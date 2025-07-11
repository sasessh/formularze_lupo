import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:checklist/models/file_data.dart';
import 'package:checklist/screens/form_screen.dart';
import 'package:checklist/screens/file_open_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formularze LuPo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(146, 255, 0, 0),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Formularze LuPo'),
      supportedLocales: const [Locale('pl', 'PL')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorObservers: [routeObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  List<RecentFileInfo> recentFiles = [];
  bool loadingFiles = true;
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadRecentFiles();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'v ${packageInfo.version}';
    });
  }

  Future<void> _loadRecentFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
        Directory(
            dir.path,
          ).listSync().where((f) => f.path.endsWith('.json')).toList()
          ..sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
          );

    final List<RecentFileInfo> recent = [];
    for (final file in files) {
      try {
        final content = await File(file.path).readAsString();
        final jsonData = jsonDecode(content);
        final form = jsonData['form']?.toString() ?? 'Błąd numeru';
        final modified = file.statSync().modified;
        recent.add(RecentFileInfo(file: file, form: form, modified: modified));
      } catch (_) {
        recent.add(
          RecentFileInfo(
            file: file,
            form: "Wadliwy plik",
            modified: DateTime(1970, 1, 1),
          ),
        );
      }
    }

    setState(() {
      recentFiles = recent;
      loadingFiles = false;
    });
  }

  void _openFile(FileSystemEntity file) async {
    final content = await File(file.path).readAsString();
    final jsonData = jsonDecode(content);
    final fileData = FileData.fromJson(jsonData);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(fileData: fileData)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadRecentFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formularze Lüttgens Polska'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            iconSize: 34,
            tooltip: 'Otwórz',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FileOpenScreen()),
              );
            },
          ),
          SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Divider(thickness: 2),
              Text(
                "Witaj w aplikacji do wypełniania formularzy Lüttgens Polska.",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(" * Użyj ikony ", style: TextStyle(fontSize: 18)),
                  Icon(Icons.folder_open, size: 32),
                  Text(
                    " aby otworzyć pusty formularz z serwera.",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Text(
                ' * Każda zmiana w wypełnianym formularzu jest automatycznie zapisywana lokalnie na urządzeniu.',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                " * Możesz wrócić do częściwo wypełnionego formularza otwierając go z listy poniżej.",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                children: [
                  Text(
                    " * Po wypełnieniu formularza należy zapisać go na serwerze.",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Text(
                " * Po przesłaniu na serwer, lokalna kopia zostanie usunięta.",
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              Text(
                "Wszelkie problemy z działaniem aplikacji proszę zgłaszać do:",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Przemysław Kiełkowski",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Marcin Ostrowski",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Divider(thickness: 5),
              Row(
                children: [
                  Expanded(
                    child: const Text(
                      "Formularze lokalnie zapisane na tym urządzeniu (nie wysłane na serwer):",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.refresh),
                    iconSize: 28,
                    tooltip: 'Odśwież',
                    onPressed: () {
                      setState(() {
                        loadingFiles = true;
                      });
                      _loadRecentFiles();
                    },
                  ),
                  SizedBox(width: 20),
                ],
              ),

              loadingFiles
                  ? Expanded(
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(),
                    ),
                  )
                  : recentFiles.isEmpty
                  ? Expanded(
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text("Brak lokalnie zapisanych formularzy."),
                    ),
                  )
                  : Expanded(
                    child: ListView.builder(
                      itemCount: recentFiles.length,
                      itemBuilder: (context, index) {
                        final recent = recentFiles[index];
                        final file = recent.file;
                        final form = recent.form;
                        final modified = recent.modified;
                        return ListTile(
                          title: Text(form, style: TextStyle(fontSize: 18)),
                          subtitle: Text(
                            'Ostatnia modyfikacja: ${modified.day.toString().padLeft(2, '0')}.${modified.month.toString().padLeft(2, '0')}.${modified.year} ${modified.hour.toString().padLeft(2, '0')}:${modified.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                child: const Text('Otwórz'),
                                onPressed: () => _openFile(file),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Usuń',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Usuń plik?'),
                                          content: Text(
                                            'Czy na pewno chcesz usunąć lokalny formularz "$form"?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Anuluj'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text(
                                                'Usuń',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    await File(file.path).delete();
                                    _loadRecentFiles();
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () => _openFile(file),
                        );
                      },
                    ),
                  ),

              Divider(thickness: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/LOGO LuPo_transparent.png',
                    height: 100,
                  ),
                  Expanded(
                    child: Text(
                      appVersion,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentFileInfo {
  final FileSystemEntity file;
  final String form;
  final DateTime modified;

  RecentFileInfo({
    required this.file,
    required this.form,
    required this.modified,
  });
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
