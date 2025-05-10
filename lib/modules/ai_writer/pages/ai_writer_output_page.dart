import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/ai_humanizer_dialog.dart';
import 'package:mywords/common/widgets/detect_ai_score_widget.dart';
import 'package:mywords/common/widgets/feedback_widget.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/modules/home/cubit/home_cubit.dart';
import 'package:mywords/modules/paywall/cubit/paywall_cubit/paywall_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class AiWriterOutputPage extends StatefulWidget {
  const AiWriterOutputPage({super.key});

  @override
  State<AiWriterOutputPage> createState() => _AiWriterOutputPageState();
}

class _AiWriterOutputPageState extends State<AiWriterOutputPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchDocumentHours();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return BlocConsumer<AiWriterCubit, AiWriterState>(
      listener: (context, aiWriterState) {
        // TODO: implement listener
      },
      builder: (context, aiWriterState) {
        return Scaffold(
          appBar: CustomAppBar(title: 'AI Writer'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StepIndicator(
                  activeSteps: [1, 2, 3],
                  leftText: 'Prompt',
                  centerText: 'Purpose',
                  rightText: 'Output',
                ),
                SizedBox(height: 16.ch),
                Container(
                  height: 270.ch,
                  margin: EdgeInsets.symmetric(horizontal: 8.cw),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.cw),
                    border: Border.all(color: Color(0xffDADADA)),
                  ),
                  child: Column(
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
                        child: BlocBuilder<AiWriterCubit, AiWriterState>(
                          builder: (context, state) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(16.cw, 0, 16.cw, 0),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 16.ch),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16.ch),
                                  child: SelectableText(
                                    state.generatedText,
                                    style: context.textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<AiDetectorCubit, AiDetectorState>(
                  builder: (context, state) {
                    if (state.aiDetectorStatus == AiDetectorStatus.loading) {
                      return Container();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.ch),
                      child: DetectAiScoreWidget(aiDetectorEntity: state.aiDetectorEntity),
                    );
                  },
                ),
                FeedbackWidget(),
                SizedBox(height: 20.ch),
              ],
            ),
          ),
          bottomNavigationBar: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
            listener: (context, state) {
              if (state.aiHumanizeStatus == AiHumanizeStatus.success) {
                showDialog(context: context, builder: (context) => const AiHumanizerDialog());
              } else if (state.aiHumanizeStatus == AiHumanizeStatus.failed) {
                context.showSnackBar(state.errorMsg);
              }
            },
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.cw),
                padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30.ch),
                child: Builder(
                  builder: (context) {
                    final paywallState = context.watch<PaywallCubit>().state;

                    return PrimaryButton.gradient(
                      isLoading: state.aiHumanizeStatus == AiHumanizeStatus.loading,
                      onTap: () {
                        context.read<AiHumanizerCubit>()
                          ..setText(aiWriterState.generatedText)
                          ..humanizeText(isPremium: paywallState.isPremiumUser);
                      },
                      title: 'Humanize Text',
                      fontWeight: FontWeight.w700,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
