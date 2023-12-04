import 'package:flutter/material.dart';

class blackButtonRound extends StatefulWidget {
  final String text;
  final Function() onPressed;
  const blackButtonRound({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<blackButtonRound> createState() => _blackButtonRoundState();
}

class _blackButtonRoundState extends State<blackButtonRound> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.text),
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
