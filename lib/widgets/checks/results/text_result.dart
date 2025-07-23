import 'package:flutter/material.dart';

class TextResult extends StatelessWidget {
  final String text;
  final String value;
  final TextStyle style;

  const TextResult({
    super.key,
    required this.text,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(text, style: style)),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child:
                value.isEmpty
                    ? const Text(
                      'NIE PODANO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 230, 0, 0),
                      ),
                    )
                    : Text(
                      value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 116, 160, 255),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
