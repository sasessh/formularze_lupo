import 'package:flutter/material.dart';

class TwoTapCheck extends StatelessWidget {
  final String label;
  final String? value;
  final TextStyle style;
  final ValueChanged<String> onChanged;

  const TwoTapCheck({
    super.key,
    required this.label,
    required this.value,
    required this.style,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    int selected = switch (value) {
      "yes" => 1,
      _ => 2, // "no" lub null
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label, style: style)),
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
              ],
              selected: {selected},
              onSelectionChanged: (newSelected) {
                final int val = newSelected.first;
                switch (val) {
                  case 1:
                    onChanged("yes");
                    break;
                  case 2:
                  default:
                    onChanged("no");
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
