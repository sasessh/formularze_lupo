import 'package:flutter/material.dart';

class ThreeTapCheck extends StatelessWidget {
  final String label;
  final String? value;
  final TextStyle style;
  final ValueChanged<String> onChanged;

  const ThreeTapCheck({
    super.key,
    required this.label,
    required this.value,
    required this.style,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String normalizedValue = value ?? "no"; // domyślna wartość gdy null w json
    int selected = switch (normalizedValue) {
      "yes" => 1,
      "no" => 2,
      _ => 3,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label, style: style,)),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 1,
                  label: Text('Tak'),
                  icon: Icon(Icons.check_circle, color: Colors.green),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Nie'),
                  icon: Icon(Icons.cancel, color: Colors.red),
                ),
                ButtonSegment(value: 3, label: Text('Nie dotyczy', style: TextStyle(fontSize: 12),)),
              ],
              selected: {selected},
              onSelectionChanged: (newSelected) {
                final int val = newSelected.first;
                switch (val) {
                  case 1:
                    onChanged("yes");
                    break;
                  case 2:
                    onChanged("no");
                    break;
                  case 3:
                  default:
                    onChanged("na");
                }
              },
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}
