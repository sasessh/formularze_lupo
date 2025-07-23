import 'package:flutter/material.dart';

class FilledFormCard extends StatelessWidget {
  final String fileSplitName;
  final String fileDate;
  final VoidCallback onOpen;

  const FilledFormCard({
    super.key,
    required this.fileSplitName,
    required this.fileDate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fileSplitName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                  ),
                  onPressed: () {
                    onOpen();
                  },
                  child: const Text(
                    'Przeglądaj',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            Text(
              fileDate,
              style: TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
