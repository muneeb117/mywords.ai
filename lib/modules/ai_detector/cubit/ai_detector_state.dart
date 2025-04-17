part of 'ai_detector_cubit.dart';

enum AiDetectorStatus { initial, loading, success, failed }

class AiDetectorState {
  final AiDetectorStatus aiDetectorStatus;
  final String inputText;
  final String modelPreference;
  final String generatedText;
  final int wordCount;
  final String errorMsg;

  AiDetectorState({
    required this.errorMsg,
    required this.inputText,
    required this.modelPreference,
    required this.generatedText,
    required this.wordCount,
    required this.aiDetectorStatus,
  });

  factory AiDetectorState.initial() {
    return AiDetectorState(
      errorMsg: '',
      inputText: '',
      modelPreference: 'ChatGPT',
      generatedText: '',
      wordCount: 0,
      aiDetectorStatus: AiDetectorStatus.initial,
    );
  }

  AiDetectorState copyWith({
    String? errorMsg,
    String? text,
    String? generatedText,
    String? modelPreference,
    int? wordCount,
    AiDetectorStatus? aiDetectorStatus,
  }) {
    return AiDetectorState(
      errorMsg: errorMsg ?? this.errorMsg,
      inputText: text ?? this.inputText,
      modelPreference: modelPreference ?? this.modelPreference,
      generatedText: generatedText ?? this.generatedText,
      wordCount: wordCount ?? this.wordCount,
      aiDetectorStatus: aiDetectorStatus ?? this.aiDetectorStatus,
    );
  }
}
