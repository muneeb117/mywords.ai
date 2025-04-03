import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class TopAppIconAndTitleWidget extends StatelessWidget {
  const TopAppIconAndTitleWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: MediaQuery.paddingOf(context).top),
          Row(
            children: [
              Image.asset(
                'assets/images/png/img_app_icon.png',
                height: 45,
                width: 45,
              ),
              SizedBox(width: 4),
              Text(
                'MyWords.AI',
                style: context.textTheme.bodyLarge
                    ?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 0),
              )
            ],
          ),

        ],
      ),
    );
  }
}

