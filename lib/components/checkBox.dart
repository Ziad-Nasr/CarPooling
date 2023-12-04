import 'package:flutter/material.dart';

class MyCheckboxWithLabel extends StatelessWidget {
  final bool isChecked;
  final String label;
  final ValueChanged<bool?> onChanged;

  MyCheckboxWithLabel({
    required this.isChecked,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
        ),
        SizedBox(width: 8.0),
        Text(label),
      ],
    );
  }
}
