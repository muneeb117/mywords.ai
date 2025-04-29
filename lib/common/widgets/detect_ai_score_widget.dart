import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/modules/ai_detector/models/ai_detector_entity.dart';
import 'package:mywords/modules/ai_humanizer/cubit/ai_humanize_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class DetectAiScoreWidget extends StatelessWidget {
  final AiDetectorEntity aiDetectorEntity;

  const DetectAiScoreWidget({super.key, required this.aiDetectorEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xffDADADA))),
      child: BlocConsumer<AiHumanizerCubit, AiHumanizerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                child: Row(
                  children: [
                    Text(
                      '${aiDetectorEntity.confidencePercentage}%',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: aiDetectorEntity.isGeneratedByAI ? Color(0xffFF3D00) : AppColors.green,
                      ),
                    ),
                    SizedBox(width: 30),
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
                                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Divider(color: Color(0xffDADADA), height: 0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Third Party AI Scores', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/svg/ic_human.svg'),
                        SizedBox(width: 7),
                        Text(
                          'Human',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff45C646),
                            letterSpacing: 0,
                            wordSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 15),
                        SvgPicture.asset('assets/images/svg/ic_likely_ai.svg'),
                        SizedBox(width: 7),
                        Text(
                          'Likely AI',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFABB18),
                            letterSpacing: 0,
                            wordSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 15),
                        SvgPicture.asset('assets/images/svg/ic_ai_generated.svg'),
                        SizedBox(width: 7),
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
  const AiServicesTile({super.key, required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Color(0xffB3B3B3).withOpacity(0.15), borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetPath),
          SizedBox(width: 6),
          Text(title, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 11)),
        ],
      ),
    );
  }
}
