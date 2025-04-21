import 'package:mywords/modules/ai_detector/models/ai_detector_result.dart';

class AiDetectorEntity {
  final int confidencePercentage;
  final String predictedClass;
  final String summaryMidText;
  final String resultMessage;
  final bool isGeneratedByAI;

  AiDetectorEntity({
    required this.confidencePercentage,
    required this.isGeneratedByAI,
    required this.predictedClass,
    required this.summaryMidText,
    required this.resultMessage,
  });

  factory AiDetectorEntity.fromModel(AiDetectionResult model) {
    return AiDetectorEntity(
      predictedClass: model.predictedClass.toLowerCase(),
      confidencePercentage: (model.aiGeneratedSentences / model.totalSentences).round() * 100,
      isGeneratedByAI: ((model.aiGeneratedSentences / model.totalSentences) * 100) > 30,
      summaryMidText: "${model.aiGeneratedSentences}/${model.totalSentences}",
      resultMessage: model.resultMessage,
    );
  }

  /// Empty factory constructor
  factory AiDetectorEntity.empty() {
    return AiDetectorEntity(
      confidencePercentage: 0,
      isGeneratedByAI: true,
      predictedClass: '',
      summaryMidText: '',
      resultMessage: '',
    );
  }
}
