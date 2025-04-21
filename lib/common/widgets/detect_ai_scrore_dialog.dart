import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_detector/models/ai_detector_entity.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class DetectAiScoreDialog extends StatelessWidget {
  const DetectAiScoreDialog({super.key, required this.aiDetectorEntity});

  final AiDetectorEntity aiDetectorEntity;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffDADADA)),
        ),
        child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16) + EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        '${aiDetectorEntity.confidencePercentage}%',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: aiDetectorEntity.isGeneratedByAI ? Color(0xffFF3D00) : AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Text.rich(
                        TextSpan(
                          text: 'Your Text is likely to be written',
                          children: [
                            TextSpan(
                              text: ' by AI\n${aiDetectorEntity.summaryMidText} ',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: aiDetectorEntity.isGeneratedByAI ? Color(0xffFC5A5A) : AppColors.green,
                              ),
                              children: [
                                TextSpan(
                                  text: 'sentences AI generated',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xffDADADA), height: 0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Third Party AI Scores',
                        style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/ic_human.svg'),
                          const SizedBox(width: 7),
                          Text(
                            'Human',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff45C646),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SvgPicture.asset('assets/images/svg/ic_likely_ai.svg'),
                          const SizedBox(width: 7),
                          Text(
                            'Likely AI',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffFABB18),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SvgPicture.asset('assets/images/svg/ic_ai_generated.svg'),
                          const SizedBox(width: 7),
                          Text(
                            'AI',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Color(0xffFC5A5A),
                              letterSpacing: 0,
                              wordSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      ThirdPartyToolsWidget(aiPredictedClass: aiDetectorEntity.predictedClass),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ThirdPartyToolsWidget extends StatelessWidget {
  final String aiPredictedClass;

  const ThirdPartyToolsWidget({super.key, required this.aiPredictedClass});

  String _getContentAIScaleAsset() {
    switch (aiPredictedClass) {
      case 'ai':
        return 'assets/images/svg/ic_ai_generated.svg';
      case 'likely_ai':
        return 'assets/images/svg/ic_likely_ai.svg';
      default:
        return 'assets/images/svg/ic_human.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AiServicesTile(title: 'Content AI Scale', assetPath: _getContentAIScaleAsset()),
            SizedBox(width: 5),
            AiServicesTile(title: 'GPTZero', assetPath: _getContentAIScaleAsset()),
            SizedBox(width: 5),
            AiServicesTile(title: 'ZERO GPT', assetPath: _getContentAIScaleAsset()),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AiServicesTile(title: 'OPENAI', assetPath: _getContentAIScaleAsset()),
            SizedBox(width: 5),
            AiServicesTile(title: 'Turnitin', assetPath: _getContentAIScaleAsset()),
            SizedBox(width: 5),
            AiServicesTile(title: 'CopyLeaks', assetPath: _getContentAIScaleAsset()),
          ],
        ),
      ],
    );
  }
}

class AiServicesTile extends StatelessWidget {
  const AiServicesTile({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xffB3B3B3).withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath),
          SizedBox(width: 6),
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
