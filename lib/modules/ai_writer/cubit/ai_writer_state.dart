part of 'ai_writer_cubit.dart';

enum AiWriterStatus { initial, loading, success, failed }

class AiWriterState {
  final AiWriterStatus aiWriterStatus;
  final String inputText;
  final String generatedText;
  final int wordCount;
  final String errorMsg;

  AiWriterState({
    required this.errorMsg,
    required this.inputText,
    required this.generatedText,
    required this.wordCount,
    required this.aiWriterStatus,
  });

  factory AiWriterState.initial() {
    return AiWriterState(
      errorMsg: '',
      inputText: '',
      generatedText: '',
      wordCount: 0,
      aiWriterStatus: AiWriterStatus.initial,
    );
  }

  AiWriterState copyWith({
    String? errorMsg,
    String? text,
    String? generatedText,
    int? wordCount,
    AiWriterStatus? aiWriterStatus,
  }) {
    return AiWriterState(
      errorMsg: errorMsg ?? this.errorMsg,
      inputText: text ?? this.inputText,
      generatedText: generatedText ?? this.generatedText,
      wordCount: wordCount ?? this.wordCount,
      aiWriterStatus: aiWriterStatus ?? this.aiWriterStatus,
    );
  }
}
