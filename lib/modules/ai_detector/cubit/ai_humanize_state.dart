part of 'ai_humanize_cubit.dart';

enum AiDetectorStatus { initial, loading, success, failed }

class AiDetectorState {
  final AiDetectorStatus aiDetectorStatus;
  final String inputText;
  final String generatedText;
  final int wordCount;
  final String errorMsg;

  AiDetectorState({
    required this.errorMsg,
    required this.inputText,
    required this.generatedText,
    required this.wordCount,
    required this.aiDetectorStatus,
  });

  factory AiDetectorState.initial() {
    return AiDetectorState(
      errorMsg: '',
      inputText: '',
      generatedText: '',
      wordCount: 0,
      aiDetectorStatus: AiDetectorStatus.initial,
    );
  }

  AiDetectorState copyWith({
    String? errorMsg,
    String? text,
    String? generatedText,
    int? wordCount,
    AiDetectorStatus? aiDetectorStatus,
  }) {
    return AiDetectorState(
      errorMsg: errorMsg ?? this.errorMsg,
      inputText: text ?? this.inputText,
      generatedText: generatedText ?? this.generatedText,
      wordCount: wordCount ?? this.wordCount,
      aiDetectorStatus: aiDetectorStatus ?? this.aiDetectorStatus,
    );
  }
}