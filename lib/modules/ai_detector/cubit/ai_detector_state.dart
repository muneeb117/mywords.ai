part of 'ai_detector_cubit.dart';

enum AiDetectorStatus { initial, loading, success, failed }

class AiDetectorState {
  final AiDetectorStatus aiDetectorStatus;
  final String inputText;
  final String modelPreference;
  final String errorMsg;
  final int wordCount;
  final AiDetectorEntity aiDetectorEntity;

  AiDetectorState({
    required this.errorMsg,
    required this.inputText,
    required this.modelPreference,
    required this.wordCount,
    required this.aiDetectorStatus,
    required this.aiDetectorEntity,
  });

  factory AiDetectorState.initial() {
    return AiDetectorState(
      errorMsg: '',
      inputText: '',
      modelPreference: 'ChatGPT',
      wordCount: 0,
      aiDetectorEntity: AiDetectorEntity.empty(),
      aiDetectorStatus: AiDetectorStatus.initial,
    );
  }

  AiDetectorState copyWith({
    String? errorMsg,
    String? inputText,
    String? modelPreference,
    int? wordCount,
    AiDetectorEntity? aiDetectorEntity,
    AiDetectorStatus? aiDetectorStatus,
  }) {
    return AiDetectorState(
      errorMsg: errorMsg ?? this.errorMsg,
      inputText: inputText ?? this.inputText,
      modelPreference: modelPreference ?? this.modelPreference,
      wordCount: wordCount ?? this.wordCount,
      aiDetectorEntity: aiDetectorEntity ?? this.aiDetectorEntity,
      aiDetectorStatus: aiDetectorStatus ?? this.aiDetectorStatus,
    );
  }
}
