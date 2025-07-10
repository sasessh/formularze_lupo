import 'package:checklist/config/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberCheck extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const NumberCheck({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumberCheck> createState() => _NumberCheckState();
}

class _NumberCheckState extends State<NumberCheck> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(covariant NumberCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  void _handleChange() {
    if (_controller.text != widget.value) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(widget.label, style: AppStyles.checkLabelStyle,)),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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