import 'package:mywords/modules/ai_detector/models/ai_detector_result.dart';

class AiDetectorEntity {
  final int confidencePercentage;
  final String label;
  final String summaryMidText;
  final String resultMessage;
  final bool isGeneratedByAI;

  AiDetectorEntity({
    required this.confidencePercentage,
    required this.isGeneratedByAI,
    required this.label,
    required this.summaryMidText,
    required this.resultMessage,

  });

  factory AiDetectorEntity.fromModel(AiDetectionResult model) {
    final probs = model.classProbabilities;

    String label;
    if (probs.ai >= 0.8) {
      label = "AI";
    } else if (probs.human >= 0.8) {
      label = "Human";
    } else {
      label = "Likely AI";
    }

    return AiDetectorEntity(
      confidencePercentage: (model.confidence * 100).round(),
      isGeneratedByAI: (model.confidence * 100).round() >= 80,
      label: label,
      summaryMidText: "${model.aiGeneratedSentences}/${model.totalSentences}",
      resultMessage: model.resultMessage,
    );
  }

  /// Empty factory constructor
  factory AiDetectorEntity.empty() {
    return AiDetectorEntity(
      confidencePercentage: 0,
      isGeneratedByAI: true,
      label: '',
      summaryMidText: '',
      resultMessage: '',
    );
  }
}
