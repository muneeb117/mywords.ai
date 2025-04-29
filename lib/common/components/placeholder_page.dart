import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class PlaceHolderPage extends StatelessWidget {
  const PlaceHolderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('$title Page', style: context.textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w500))),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.keyboard_backspace), SizedBox(width: 8), Text('Go Back')],
            ),
          ),
        ],
      ),
    );
  }
}
