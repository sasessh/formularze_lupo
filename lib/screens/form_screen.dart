import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:checklist/services/smb_service.dart';
import 'package:path_provider/path_provider.dart';
import '../models/file_data.dart';
import '../models/check_item.dart';
import '../widgets/checks/text_check.dart';
import '../widgets/checks/number_check.dart';
import '../widgets/checks/deciaml_check.dart';
import '../widgets/checks/datetime_check.dart';
import '../widgets/checks/threetap_check.dart';
import '../widgets/checks/twotap_check.dart';
import '../widgets/checks/dropdown_check.dart';
import '../widgets/checks/label_check.dart';
import '../widgets/checks/separator_check.dart';
import '../widgets/checks/group_check.dart';

class FormScreen extends StatefulWidget {
  final FileData fileData;

  const FormScreen({super.key, required this.fileData});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late List<CheckItem> checks;

  @override
  void initState() {
    super.initState();
    checks = widget.fileData.checks.map((e) => e.copy()).toList();
  }

  Future<void> _saveToFile() async {
    final updatedFileData = widget.fileData.copyWith(checks: checks);
    final jsonString = jsonEncode(updatedFileData.toJson());
    final dir = await getApplicationDocumentsDirectory();
    final id = widget.fileData.localId ?? 'brak_id';
    final file = File('${dir.path}/${widget.fileData.form}_$id.json');
    await file.writeAsString(jsonString);
  }

  Future<void> _saveToServer() async {
    try {
      final updatedFileData = widget.fileData.copyWith(checks: checks);
      final jsonString = jsonEncode(updatedFileData.toJson());

      final smbService = SmbService();

      List<String> collectFilenameValues(List<CheckItem> checks) {
        final List<String> result = [];
        for (final c in checks) {
          if (c.inFilename && c.value != null && c.value!.isNotEmpty) {
            result.add(c.value!.replaceAll(' ', '_'));
          }
          if (c.children != null && c.children!.isNotEmpty) {
            result.addAll(collectFilenameValues(c.children!));
          }
        }
        return result;
      }

      final filenameParts = collectFilenameValues(checks);
      final checksInFilename = filenameParts.join('_');

      final id = widget.fileData.localId ?? 'brak_id';
      final now = DateTime.now();
      final formatted =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
      final fileName =
          '${widget.fileData.form}_${checksInFilename}_$formatted.json';

      await smbService.saveFileToDirectoryWithSubfolders(
        fileName,
        jsonString,
        widget.fileData.form,
      );

      final dir = await getApplicationDocumentsDirectory();
      final localFile = File('${dir.path}/${widget.fileData.form}_$id.json');
      if (await localFile.exists()) {
        await localFile.delete();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lista została zapisana na serwerze i usunięta lokalnie.',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd zapisu na serwerze: $e')));
      }
    }
  }

  void _onCheckChanged(int index, CheckItem newCheck) {
    setState(() {
      checks[index] = newCheck;
    });
    _saveToFile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Listy kontrolne Lüttgens Polska')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        widget.fileData.form,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Wersja: ${widget.fileData.version}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.fileData.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(thickness: 2),
            const SizedBox(height: 16),
            ...List.generate(
              checks.length,
              (i) => _buildCheckWidget(checks[i], i),
            ),
            Divider(thickness: 2),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Utworzył: ${widget.fileData.createdBy}"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Zatwierdził: ${widget.fileData.creationValidatedBy}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Data utworzenia: ${widget.fileData.createdDate}",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Aktualizował: ${widget.fileData.modifiedBy}"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Zatwierdził: ${widget.fileData.modificationValidatedBy}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Data aktualizacji: ${widget.fileData.modifiedDate}",
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Potwierdzenie'),
                        content: const Text(
                          'Czy na pewno chcesz wysłać listę na serwer?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Nie'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),

                            child: const Text(
                              'Tak',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 255, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirmed == true) {
                  await _saveToServer();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color.fromARGB(31, 255, 255, 255),
                ),
              ),
              child: Text(
                "Zapisz na serwerze",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckWidget(
    CheckItem check,
    int index, [
    void Function(CheckItem)? onChanged,
  ]) {
    switch (check.type) {
      case 'text':
        return TextCheck(
          label: check.text,
          value: check.value ?? '',
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case 'number':
        return NumberCheck(
          label: check.text,
          value: check.value ?? '',
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case 'decimal':
        return DecimalCheck(
          label: check.text,
          value: check.value ?? '',
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case 'datetime':
        return DateTimeCheck(
          label: check.text,
          value: check.value,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case '3-tap':
        return ThreeTapCheck(
          label: check.text,
          value: check.value,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case '2-tap':
        return TwoTapCheck(
          label: check.text,
          value: check.value,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(value: val));
            } else {
              _onCheckChanged(index, check.copyWith(value: val));
            }
          },
        );
      case 'list':
        return DropdownCheck(
          label: check.text,
          options: check.options ?? [],
          value: check.selected,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(check.copyWith(selected: val));
            } else {
              _onCheckChanged(index, check.copyWith(selected: val));
            }
          },
        );
      case 'label':
        return LabelCheck(label: check.text);
      case 'separator':
        return SeparatorCheck(title: check.text);
      case 'group':
        return GroupCheck(
          label: check.text,
          children: check.children ?? [],
          buildCheckWidget:
              (child, childIndex) =>
                  _buildCheckWidget(child, childIndex, (newChild) {
                    final newChildren = List<CheckItem>.from(check.children!);
                    newChildren[childIndex] = newChild;
                    final newGroup = check.copyWith(children: newChildren);
                    if (onChanged != null) {
                      onChanged(newGroup);
                    } else {
                      _onCheckChanged(index, newGroup);
                    }
                  }),
          optional: check.optional,
          used: check.used,
          onUsedChanged: (value) {
            if (onChanged != null) {
              onChanged(check.copyWith(used: value));
            } else {
              _onCheckChanged(index, check.copyWith(used: value));
            }
          },
        );
      default:
        if (onChanged != null) {
          return TextCheck(
            label: check.text,
            value: check.value ?? '',
            onChanged: (val) => onChanged(check.copyWith(value: val)),
          );
        } else {
          return TextCheck(
            label: check.text,
            value: check.value ?? '',
            onChanged:
                (val) => _onCheckChanged(index, check.copyWith(value: val)),
          );
        }
    }
  }
}
