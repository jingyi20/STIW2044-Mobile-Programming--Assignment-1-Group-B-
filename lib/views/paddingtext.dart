import 'package:flutter/material.dart';

class PaddingText extends StatelessWidget {
  final String text;

  const PaddingText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));
  }
}