import 'package:flutter/material.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/di/service_locator.dart' show sl;
import 'package:mywords/modules/home/widgets/current_plan_widget.dart';
import 'package:mywords/modules/home/widgets/home_header.dart';
import 'package:mywords/modules/home/widgets/home_tool_widget.dart';
import 'package:mywords/modules/home/widgets/hours_saved_widget.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Padding(padding: const EdgeInsets.only(top: 10.0), child: HomeHeader()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Divider(color: Color(0xffEEEEEE), height: 0),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [Expanded(child: CurrentPlanWidget()), SizedBox(width: 12), Expanded(child: HoursSavedWidget())]),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Popular Tools', style: context.textTheme.titleMedium),
          ),
          SizedBox(height: 8),
          HomeToolWidget(
            onTap: () {
              sl<AnalyticsService>().logEvent(name: AnalyticsEventNames.aiWriterInitiated);
              Navigator.pushNamed(context, RouteManager.aiWriterInput);
            },
            title: 'AI Writer',
            description: 'Lorem ipsum is a dummy. Lorem ipsum is a dummy text.',
            imageAssetPath: 'assets/images/png/img_ai_writer.png',
          ),
          SizedBox(height: 10),
          HomeToolWidget(
            onTap: () {
              sl<AnalyticsService>().logEvent(name: AnalyticsEventNames.aiHumanizerInitiated);
              Navigator.pushNamed(context, RouteManager.aiHumanizerInput);
            },
            title: 'AI Humanizer',
            description: 'Lorem ipsum is a dummy. Lorem ipsum is a dummy text.',
            imageAssetPath: 'assets/images/png/img_ai_humanizer.png',
          ),
          SizedBox(height: 10),
          HomeToolWidget(
            onTap: () {
              sl<AnalyticsService>().logEvent(name: AnalyticsEventNames.aiDetectorInitiated);
              Navigator.pushNamed(context, RouteManager.aiDetectorInput);
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
