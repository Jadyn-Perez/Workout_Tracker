import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.function,
    required this.text,
  });

  final Function function;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(),
        onPressed: () {
          function();
        },
        child: Text(text));
  }
}
