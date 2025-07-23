import 'package:flutter/material.dart';

class TapResult extends StatelessWidget {
  final String text;
  final String value;
  final TextStyle style;

  const TapResult({super.key, required this.text, required this.value, required this.style});

  Widget _formatTapValue(String tapValue) {
    switch (tapValue) {
      case 'yes':
        return Text(
              'Tak',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 0, 150, 25),
              ),
            );
      case 'na':
        return Text(
              'Nie dotyczy',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 214, 146, 0),
              ),
            );
      case 'no':
      case '':
        return Text(
              'Nie',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 230, 0, 0),
              ),
            );

      default:
        return Text(
              'Brak danych',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(text, style: style),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _formatTapValue(value),
          ),
        ],
      ),
    );
  }
}
