import 'package:flutter/material.dart';

class SeparatorCheck extends StatelessWidget {
  final String title;
  final TextStyle style;

  const SeparatorCheck({super.key, required this.title, required this.style});

  @override
  Widget build(BuildContext context) {
    final double maxTextWidth = MediaQuery.of(context).size.width * 0.9;

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 5),
              child: const Divider(thickness: 8),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxTextWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                title,
                style: style,
                overflow: TextOverflow.visible,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 5),
              child: const Divider(thickness: 8),
            ),
          ),
        ],
      ),
    );
  }
}
