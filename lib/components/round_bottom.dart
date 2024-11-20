import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton(
      {super.key, required this.title,
      required this.onPress,
      required MaterialColor color});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.indigo,
        height: 50,
        minWidth: double.infinity,
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
