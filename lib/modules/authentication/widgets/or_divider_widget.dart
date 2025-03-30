import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: context.textTheme.titleMedium?.copyWith(color: Color(0xff616161), fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
