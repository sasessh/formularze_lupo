import 'package:flutter/material.dart';

class DropdownCheck extends StatelessWidget {
  final String label;
  final List<String> options;
  final TextStyle style;
  final String? value;
  final ValueChanged<String?> onChanged;

  const DropdownCheck({
    super.key,
    required this.label,
    required this.options,
    required this.style,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: style,),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: value != null && value != 'none' ? value : null,
              items: options
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}