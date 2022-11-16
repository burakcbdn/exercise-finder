import 'package:flutter/material.dart';

// shows info on states like error or empty
class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoBox({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.purple, size: 50),
            const SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
