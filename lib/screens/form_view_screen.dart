import 'package:checklist/models/file_data.dart';
import 'package:checklist/models/check_item.dart';
import 'package:checklist/widgets/checks/label_check.dart';
import 'package:checklist/widgets/checks/results/datetime_result.dart';
import 'package:checklist/widgets/checks/results/tap_result.dart';
import 'package:checklist/widgets/checks/results/text_result.dart';
import 'package:checklist/widgets/checks/separator_check.dart';
import 'package:flutter/material.dart';

import '../widgets/checks/results/group_result.dart';

class FormViewScreen extends StatefulWidget {
  final FileData formFile;

  const FormViewScreen({super.key, required this.formFile});

  @override
  State<FormViewScreen> createState() => _FormViewScreenState();
}

class _FormViewScreenState extends State<FormViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Przegląd formularza ${widget.formFile.form}"),
        ),
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
                        widget.formFile.form,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Wersja: ${widget.formFile.version}'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.formFile.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 16),

            ...List.generate(
              widget.formFile.checks.length,
              (i) => _buildResultWidget(widget.formFile.checks[i], i),
            ),

            const Divider(thickness: 2),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Utworzył: ${widget.formFile.createdBy}"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Zatwierdził: ${widget.formFile.creationValidatedBy}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Data utworzenia: ${widget.formFile.createdDate}",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Aktualizował: ${widget.formFile.modifiedBy}"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Zatwierdził: ${widget.formFile.modificationValidatedBy}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Data aktualizacji: ${widget.formFile.modifiedDate}",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget(CheckItem check, int index) {
    switch (check.type) {
      case "number":
      case "decimal":
      case 'text':
        return TextResult(text: check.text, value: check.value ?? '');

      case 'list':
        return TextResult(text: check.text, value: check.selected ?? '');

      case 'datetime':
        return DatetimeResult(text: check.text, value: check.value ?? '');

      case '2-tap':
      case '3-tap':
        return TapResult(text: check.text, value: check.value ?? '');

      case 'separator':
        return SeparatorCheck(title: check.text);

      case 'label':
        return LabelCheck(label: check.text);

      case 'group':
        return GroupResult(
          label: check.text,
          children: check.children ?? [],
          optional: check.optional,
          used: check.used,
          buildResultWidget:
              _buildResultWidget,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
