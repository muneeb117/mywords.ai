import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_dropdown_without_icon.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_humanize_cubit.dart';
import 'package:mywords/modules/ai_detector/pages/ai_detector_output_page.dart';
import 'package:mywords/modules/ai_writer/cubit/ai_writer_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiDetectorPreferencePage extends StatefulWidget {
  const AiDetectorPreferencePage({super.key});

  @override
  State<AiDetectorPreferencePage> createState() => _AiDetectorPreferencePageState();
}

class _AiDetectorPreferencePageState extends State<AiDetectorPreferencePage> {
  final TextEditingController aiWriterController = TextEditingController();

  String? writingPurpose = 'Essay';
  String selectedLanguage = 'English';
  TextEditingController minWordCountController = TextEditingController();
  TextEditingController maxWordCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Detector'),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepIndicator(
                activeSteps: [1, 2],
                leftText: 'Input',
                centerText: 'Preference',
                rightText: 'Output',
              ),
              SizedBox(height: 16),
              Container(
                  height: 250,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xffDADADA),
                    ),
                  ),
                  child: BlocConsumer<AiWriterCubit, AiWriterState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: Text(
                              'Output',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffDADADA),
                            height: 0,
                          ),
                          Expanded(
                            child: BlocBuilder<AiWriterCubit, AiWriterState>(
                              builder: (context, state) {
                                return Container(
                                  width: double.infinity,
                                  height: 300,
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: SingleChildScrollView(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: SelectableText(
                                          state.generatedText,
                                          style: context.textTheme.titleMedium,
                                        ),
                                      )),
                                  decoration: BoxDecoration(),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30),
        child: BlocConsumer<AiDetectorCubit, AiDetectorState>(
          listener: (context, state) {
            if (state.aiDetectorStatus == AiDetectorStatus.success) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AiDetectorOutputPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else if (state.aiDetectorStatus == AiDetectorStatus.failed) {
              context.showSnackBar(state.errorMsg);
            }
          },
          builder: (context, state) {
            return PrimaryButton.gradient(
              isLoading: state.aiDetectorStatus == AiDetectorStatus.loading,
              onTap: () {
                final minText = minWordCountController.text.trim();
                final maxText = maxWordCountController.text.trim();

                final min = int.tryParse(minText);
                final max = int.tryParse(maxText);

                if (min == null || max == null || min < 350 || max > 500) {
                  context.showSnackBar('Please enter valid word limits!', isError: true);
                  return;
                }
                context.read<AiDetectorCubit>().detectText();
              },
              title: 'Generate Outline',
              iconPath: 'assets/images/svg/ic_flag.svg',
              fontWeight: FontWeight.w700,
            );
          },
        ),
      ),
    );
  }
}
