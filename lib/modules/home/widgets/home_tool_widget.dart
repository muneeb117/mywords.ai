import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class HomeToolWidget extends StatelessWidget {
  const HomeToolWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.imageAssetPath,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: Color(0xffEEEEEE),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 110,
              width: 117,
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: LinearGradient(colors: [
                  Color(0xffCE4AEF),
                  Color(0xff601FBE),
                ]),
              ),
              child: Image.asset(imageAssetPath),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SvgPicture.asset('assets/images/svg/ic_arrow_forward.svg'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
