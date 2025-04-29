import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.onTap, required this.title, required this.assetPath, this.textColor});

  final String title;
  final String assetPath;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(assetPath, height: 45, width: 45),
            SizedBox(width: 14),
            Text(title, style: context.textTheme.titleMedium?.copyWith(color: textColor ?? context.colorScheme.onSurface)),
            Spacer(),
            Icon(Icons.arrow_forward_ios_outlined, color: Colors.black.withOpacity(0.3), size: 20),
          ],
        ),
      ),
    );
  }
}
