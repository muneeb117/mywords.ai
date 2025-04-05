part of 'ai_writer_cubit.dart';

enum AiWriterStatus { initial, loading, success, failed }

class AiWriterState {
  final AiWriterStatus aiWriterStatus;
  final String text;
  final int wordCount;
  final String errorMsg;

  AiWriterState({
    required this.errorMsg,
    required this.text,
    required this.wordCount,
    required this.aiWriterStatus,
  });

  factory AiWriterState.initial() {
    return AiWriterState(
      errorMsg: '',
      text: '',
      wordCount: 0,
      aiWriterStatus: AiWriterStatus.initial,
    );
  }

  AiWriterState copyWith({
    String? errorMsg,
    String? text,
    int? wordCount,
    AiWriterStatus? aiWriterStatus,
  }) {
    return AiWriterState(
      errorMsg: errorMsg ?? this.errorMsg,
      text: text ?? this.text,
      wordCount: wordCount ?? this.wordCount,
      aiWriterStatus: aiWriterStatus ?? this.aiWriterStatus,
    );
  }
}