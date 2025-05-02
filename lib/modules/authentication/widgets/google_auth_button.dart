import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class SocialAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;

  const SocialAuthButton({super.key, required this.onTap, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 56,
            width: double.infinity,

            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffEDF1F3)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SvgPicture.asset(iconPath, height: 30, width: 30),
              ),
            ),
          ),
          Text('Continue with Google', style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}
