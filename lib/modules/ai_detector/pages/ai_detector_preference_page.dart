import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';

import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/common/widgets/step_indicator_widget.dart';
import 'package:mywords/modules/ai_detector/cubit/ai_detector_cubit.dart';
import 'package:mywords/modules/ai_detector/pages/ai_detector_output_page.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AiDetectorPreferencePage extends StatefulWidget {
  const AiDetectorPreferencePage({super.key});

  @override
  State<AiDetectorPreferencePage> createState() => _AiDetectorPreferencePageState();
}

class _AiDetectorPreferencePageState extends State<AiDetectorPreferencePage> {
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
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xffDADADA),
                    ),
                  ),
                  child: BlocConsumer<AiDetectorCubit, AiDetectorState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: Text(
                              'Select Preference',
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
                          SizedBox(height: 16),
                          DetectorPreferenceTile(
                            title: 'ChatGPT',
                            isSelected: state.modelPreference == 'ChatGPT',
                          ),
                          SizedBox(height: 8),
                          DetectorPreferenceTile(
                            title: 'GPT-4',
                            isSelected: state.modelPreference == 'GPT-4',
                          ),
                          SizedBox(height: 8),
                          DetectorPreferenceTile(
                            title: 'Human',
                            isSelected: state.modelPreference == 'Human',
                          ),
                          SizedBox(height: 8),
                          DetectorPreferenceTile(
                            title: 'Human + AI',
                            isSelected: state.modelPreference == 'Human + AI',
                          ),
                          SizedBox(height: 16),
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

class DetectorPreferenceTile extends StatelessWidget {
  const DetectorPreferenceTile({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AiDetectorCubit>().setPreference(title);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? context.colorScheme.secondary.withOpacity(0.10) : Colors.transparent,
          border: Border.all(color: Color(0xffEAECF0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(color: isSelected ? context.colorScheme.primary : null),
        ),
      ),
    );
  }
}
