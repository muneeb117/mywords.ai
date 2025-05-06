import 'package:flutter/material.dart';
import 'package:mywords/config/routes/route_manager.dart';

void showUpgradeDialog(BuildContext context, {required int remainingWords}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Limit Exceeded'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have $remainingWords words remaining in the free version.\n\nUpgrade to Pro for unlimited word access and continue without restrictions or reduce your input.',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Maybe Later')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteManager.payWall);
            },
            child: Text('Upgrade Now'),
          ),
        ],
      );
    },
  );
}
