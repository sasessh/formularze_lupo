import 'package:flutter/material.dart';

class LabelCheck extends StatelessWidget {
  final String label;
  final TextStyle style;

  const LabelCheck({super.key, required this.label, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(children: [Expanded(child: Text(label, style: style))]),
    );
  }
}
