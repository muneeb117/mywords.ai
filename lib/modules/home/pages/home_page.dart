import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/modules/home/widgets/current_plan_widget.dart';
import 'package:mywords/modules/home/widgets/home_header.dart';
import 'package:mywords/modules/home/widgets/hours_saved_widget.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top),
          HomeHeader(),
          Divider(color: Color(0xffEEEEEE)),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: CurrentPlanWidget()),
                SizedBox(width: 12),
                Expanded(child: HoursSavedWidget()),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Tools',
              style: context.textTheme.titleMedium,
            ),
          ),
          SizedBox(height: 16),
          HomeToolWidget(
            onTap: () {
              Navigator.pushNamed(context, RouteManager.writer);
            },
            title: 'AI Writer',
            description: 'Lorem ipsum is a dummy. Lorem ipsum is a dummy text.',
            imageAssetPath: 'assets/images/png/img_ai_writer.png',
          ),
          SizedBox(height: 10),
          HomeToolWidget(
            onTap: () {
              Navigator.pushNamed(context, RouteManager.humanizer);
            },
            title: 'AI Humanizer',
            description: 'Lorem ipsum is a dummy. Lorem ipsum is a dummy text.',
            imageAssetPath: 'assets/images/png/img_ai_humanizer.png',
          ),
          SizedBox(height: 10),
          HomeToolWidget(
            onTap: () {
              Navigator.pushNamed(context, RouteManager.detector);
            },
            title: 'AI Detector',
            description: 'Lorem ipsum is a dummy. Lorem ipsum is a dummy text.',
            imageAssetPath: 'assets/images/png/img_ai_detector.png',
          ),
        ],
      ),
    );
  }
}

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
