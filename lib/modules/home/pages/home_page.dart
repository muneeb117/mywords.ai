import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/di/service_locator.dart' show sl;
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/modules/home/widgets/current_plan_widget.dart';
import 'package:mywords/modules/home/widgets/home_header.dart';
import 'package:mywords/modules/home/widgets/home_tool_widget.dart';
import 'package:mywords/modules/home/widgets/hours_saved_widget.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchDocumentHours();
    context.read<PaywallCubit>().getOfferings();
    context.read<PaywallCubit>().getEntitlement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Padding(padding: EdgeInsets.only(top: 10.ch), child: HomeHeader()),
      ),
      body: BlocConsumer<PaywallCubit, PaywallState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimateList(
              interval: 150.ms,
              effects: [
                FadeEffect(duration: 600.ms, curve: Curves.easeInOut),
                SlideEffect(begin: Offset(0, 0.1), duration: 600.ms, curve: Curves.easeInOut),
              ],
              children: [
                SizedBox(height: 4.ch),
                Divider(color: Color(0xffEEEEEE), height: 0),
                SizedBox(height: 16.ch),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.cw),
                  child: Row(
                    children: [
                      Expanded(child: CurrentPlanWidget()),
                      SizedBox(width: 12.cw),
                      Expanded(child: HoursSavedWidget()),
                    ],
                  ),
                ),
                SizedBox(height: 16.ch),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.cw),
                  child: Text('Popular Tools', style: context.textTheme.titleMedium),
                ),
                SizedBox(height: 8.ch),
                HomeToolWidget(
                  onTap: () {
                    if (state.isPremiumUser) {
                      sl<AnalyticsService>().logEvent(name: AnalyticsEventNames.aiWriterInitiated);
                      Navigator.pushNamed(context, RouteManager.aiWriterInput);
                    } else {
                      Navigator.pushNamed(context, RouteManager.payWall);
                    }
                  },
                  title: 'AI Writer',
                  description: 'Quickly write essays, emails, posts, and more with AI.',
                  imageAssetPath: 'assets/images/png/img_ai_writer.png',
                ),
                SizedBox(height: 10.ch),
                HomeToolWidget(
                  onTap: () async {
                    if (state.isPremiumUser) {
                      sl<AnalyticsService>().logEvent(
                        name: AnalyticsEventNames.aiHumanizerInitiated,
                      );
                      Navigator.pushNamed(context, RouteManager.aiHumanizerInput);
                    } else {
                      Navigator.pushNamed(context, RouteManager.payWall);
                    }
                  },
                  title: 'AI Humanizer',
                  description: 'Make any AI text sound human bypass detection tools like Turnitin, GPTZero, and others.',
                  imageAssetPath: 'assets/images/png/img_ai_humanizer.png',
                ),
                SizedBox(height: 10.ch),
                HomeToolWidget(
                  onTap: () {
                    if (state.isPremiumUser) {
                      sl<AnalyticsService>().logEvent(
                        name: AnalyticsEventNames.aiDetectorInitiated,
                      );
                      Navigator.pushNamed(context, RouteManager.aiDetectorInput);
                    } else {
                      Navigator.pushNamed(context, RouteManager.payWall);
                    }
                  },
                  title: 'AI Detector',
                  description: 'Check if your text is AI-written or human-made.',
                  imageAssetPath: 'assets/images/png/img_ai_detector.png',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
