import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/ai_humanizer_dialog.dart';
import 'package:mywords/common/widgets/detect_ai_score_widget.dart';
import 'package:mywords/common/widgets/show_upgrade_dialog.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class AiDetectorOutputPage extends StatefulWidget {
  const AiDetectorOutputPage({super.key});

  @override
  State<AiDetectorOutputPage> createState() => _AiDetectorOutputPageState();
}

class _AiDetectorOutputPageState extends State<AiDetectorOutputPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchDocumentHours();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return BlocConsumer<AiDetectorCubit, AiDetectorState>(
      listener: (context, aiDetectorState) {
        // TODO: implement listener
      },
      builder: (context, aiDetectorState) {
        return Scaffold(
          appBar: CustomAppBar(title: 'AI Detector'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StepIndicator(
                  activeSteps: [1, 2, 3],
                  leftText: 'Input',
                  centerText: 'Preference',
                  rightText: 'Output',
                ),
                SizedBox(height: 16.ch),
                Container(
                  height: 300.ch,
                  margin: EdgeInsets.symmetric(horizontal: 8.cw),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.cr),
                    border: Border.all(color: Color(0xffDADADA)),
                  ),
                  child: BlocConsumer<AiDetectorCubit, AiDetectorState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.cw, vertical: 16.ch),
                            child: Text(
                              'Output',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Divider(color: Color(0xffDADADA), height: 0),
                          Expanded(
                            child: BlocBuilder<AiDetectorCubit, AiDetectorState>(
                              builder: (context, state) {
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(16.cw, 0, 16.cw, 0),
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.only(top: 16.ch),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 16.ch),
                                      child: SelectableText(
                                        state.inputText,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.ch),
                DetectAiScoreWidget(aiDetectorEntity: aiDetectorState.aiDetectorEntity),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.cw),
            padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30.ch),
            child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
              listener: (context, state) {
                if (state.aiHumanizeStatus == AiHumanizeStatus.success) {
                  showDialog(context: context, builder: (context) => const AiHumanizerDialog());
                } else if (state.aiHumanizeStatus == AiHumanizeStatus.limitExceeded) {
                  showUpgradeDialog(context, remainingWords: state.wordsLeft);
                } else if (state.aiHumanizeStatus == AiHumanizeStatus.failed) {
                  context.showSnackBar(state.errorMsg);
                }
              },
              builder: (context, state) {
                return Builder(
                  builder: (context) {
                    final paywallState = context.watch<PaywallCubit>().state;

                    return PrimaryButton.gradient(
                      title: 'Humanize Text',
                      fontWeight: FontWeight.w700,
                      isLoading: state.aiHumanizeStatus == AiHumanizeStatus.loading,
                      onTap: () {
                        context.read<AiHumanizerCubit>()
                          ..setText(aiDetectorState.inputText)
                          ..humanizeText(isPremium: paywallState.isPremiumUser);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
