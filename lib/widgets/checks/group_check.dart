import 'package:flutter/material.dart';
import '../../models/check_item.dart';

class GroupCheck extends StatelessWidget {
  final String label;
  final List<CheckItem> children;
  final Widget Function(CheckItem, int) buildCheckWidget;
  final TextStyle style;
  final bool optional;
  final bool used;
  final Function(bool)? onUsedChanged;

  const GroupCheck({
    super.key,
    required this.label,
    required this.children,
    required this.buildCheckWidget,
    required this.style,
    this.optional = false,
    this.used = false,
    this.onUsedChanged,
  });

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(120, 255, 255, 255),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty || optional)
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 20),
              child: Row(
                children: [
                  Text(
                    label,
                    style: style,
                  ),
                  if (optional)
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          thumbIcon: thumbIcon,
                          value: used,
                          onChanged: onUsedChanged,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (!optional || used)
            ...List.generate(
              children.length,
              (index) => buildCheckWidget(children[index], index),
            ),
        ],
      ),
    );
  }
}
