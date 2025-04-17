part of 'ai_humanize_cubit.dart';

enum AiHumanizeStatus { initial, loading, success, failed }

class AiHumanizerState {
  final AiHumanizeStatus aiHumanizeStatus;
  final String inputText;
  final String generatedText;
  final int wordCount;
  final int generatedOutputWordCount;
  final String errorMsg;

  AiHumanizerState({
    required this.errorMsg,
    required this.inputText,
    required this.generatedText,
    required this.wordCount,
    required this.generatedOutputWordCount,
    required this.aiHumanizeStatus,
  });

  factory AiHumanizerState.initial() {
    return AiHumanizerState(
      errorMsg: '',
      inputText: '',
      generatedText: '',
      wordCount: 0,
      generatedOutputWordCount: 0,
      aiHumanizeStatus: AiHumanizeStatus.initial,
    );
  }

  AiHumanizerState copyWith({
    String? errorMsg,
    String? text,
    String? generatedText,
    int? wordCount,
    int? generatedOutputWordCount,
    AiHumanizeStatus? aiHumanizeStatus,
  }) {
    return AiHumanizerState(
      errorMsg: errorMsg ?? this.errorMsg,
      inputText: text ?? this.inputText,
      generatedText: generatedText ?? this.generatedText,
      wordCount: wordCount ?? this.wordCount,
      generatedOutputWordCount: generatedOutputWordCount ?? this.generatedOutputWordCount,
      aiHumanizeStatus: aiHumanizeStatus ?? this.aiHumanizeStatus,
    );
  }
}
