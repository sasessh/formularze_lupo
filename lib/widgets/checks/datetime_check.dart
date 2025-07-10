import 'package:checklist/config/app_styles.dart';
import 'package:flutter/material.dart';

class DateTimeCheck extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;

  const DateTimeCheck({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initial =
        value != null && value!.isNotEmpty
            ? DateTime.tryParse(value!) ?? now
            : now;
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
      );
      if (time != null) {
        final selected = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onChanged(selected.toIso8601String());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String display;
    if (value != null && value!.isNotEmpty) {
      final dt = DateTime.tryParse(value!);
      if (dt != null) {
        display =
            '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else {
        display = value!;
      }
    } else {
      display = 'Wybierz datę i godzinę';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: AppStyles.checkLabelStyle),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => _selectDateTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                child: Text(display),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
