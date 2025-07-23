import 'package:flutter/material.dart';
import 'package:checklist/models/check_item.dart';

class GroupResult extends StatelessWidget {
  final String label;
  final TextStyle style;
  final List<CheckItem> children;
  final bool optional;
  final bool used;
  final Widget Function(CheckItem, int) buildResultWidget;

  const GroupResult({
    super.key,
    required this.label,
    required this.style,
    required this.children,
    required this.buildResultWidget,
    this.optional = false,
    this.used = false,
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
                    style: style.copyWith(
                      decoration: (optional && !used)
                          ? TextDecoration.lineThrough
                          : null,
                      decorationThickness: (optional && !used) ? 2.0 : null,
                      decorationColor:
                          (optional && !used) ? const Color.fromARGB(255, 214, 146, 0) : null,
                    ),
                    // style: TextStyle(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   decoration:
                    //       (optional && !used)
                    //           ? TextDecoration.lineThrough
                    //           : null,
                    //   decorationThickness: (optional && !used) ? 2.0 : null,
                    //   decorationColor:
                    //       (optional && !used)
                    //           ? Color.fromARGB(255, 214, 146, 0)
                    //           : null,
                    // ),
                  ),
                  if (optional && !used)
                    Text(
                      '   (nie dotyczy)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 214, 146, 0)
                      ),
                    ),
                ],
              ),
            ),

          if (!optional || used)
            ...List.generate(
              children.length,
              (index) => buildResultWidget(children[index], index),
            ),
        ],
      ),
    );
  }
}
