class AiDetectionResult {
  final String predictedClass;
  final double confidence;
  final String resultMessage;
  final ClassProbabilities classProbabilities;
  final int totalSentences;
  final int aiGeneratedSentences;

  AiDetectionResult({
    required this.predictedClass,
    required this.confidence,
    required this.resultMessage,
    required this.classProbabilities,
    required this.totalSentences,
    required this.aiGeneratedSentences,
  });

  factory AiDetectionResult.fromJson(Map<String, dynamic> json) {
    return AiDetectionResult(
      predictedClass: json['predictedClass'],
      confidence: (json['confidence'] as num).toDouble(),
      resultMessage: json['resultMessage'],
      classProbabilities: ClassProbabilities.fromJson(json['classProbabilities']),
      totalSentences: json['totalSentences'],
      aiGeneratedSentences: json['aiGeneratedSentences'],
    );
  }

  /// Empty constructor
  factory AiDetectionResult.empty() {
    return AiDetectionResult(
      predictedClass: '',
      confidence: 0.0,
      resultMessage: '',
      classProbabilities: ClassProbabilities.empty(),
      totalSentences: 0,
      aiGeneratedSentences: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictedClass': predictedClass,
      'confidence': confidence,
      'resultMessage': resultMessage,
      'classProbabilities': classProbabilities.toJson(),
      'totalSentences': totalSentences,
      'aiGeneratedSentences': aiGeneratedSentences,
    };
  }
}

class ClassProbabilities {
  final double human;
  final double ai;
  final double mixed;

  ClassProbabilities({
    required this.human,
    required this.ai,
    required this.mixed,
  });

  factory ClassProbabilities.fromJson(Map<String, dynamic> json) {
    return ClassProbabilities(
      human: (json['human'] as num).toDouble(),
      ai: (json['ai'] as num).toDouble(),
      mixed: (json['mixed'] as num).toDouble(),
    );
  }

  /// Empty constructor
  factory ClassProbabilities.empty() {
    return ClassProbabilities(
      human: 0.0,
      ai: 0.0,
      mixed: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'human': human,
      'ai': ai,
      'mixed': mixed,
    };
  }
}
