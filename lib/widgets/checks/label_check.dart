import 'package:checklist/config/app_styles.dart';
import 'package:flutter/material.dart';

class LabelCheck extends StatelessWidget {
  final String label;

  const LabelCheck({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.checkLabelStyle,)),
        ],
      ),
    );
  }
}
