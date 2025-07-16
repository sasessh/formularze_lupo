import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checklist/config/app_styles.dart';

class DatetimeResult extends StatelessWidget {
  final String text;
  final String value;

  const DatetimeResult({super.key, required this.text, required this.value});

  String _formatDateTime(String isoString) {
    if (isoString.isEmpty) return '';

    try {
      DateTime dateTime = DateTime.parse(isoString);
      DateFormat formatter = DateFormat('dd.MM.yyyy   HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = _formatDateTime(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(text, style: AppStyles.checkLabelStyle),
          ),
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
                      formattedValue,
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
