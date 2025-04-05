import 'package:bloc/bloc.dart';

part 'ai_writer_state.dart';

class AiWriterCubit extends Cubit<AiWriterState> {
  AiWriterCubit() : super(AiWriterState.initial());

  void updateText(String value) {
    int wordCount = countWords(value);
    emit(state.copyWith(
      text: value,
      wordCount: wordCount,
      aiWriterStatus: AiWriterStatus.initial,
    ));
  }

  int countWords(String text) {
    return text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  }
}
