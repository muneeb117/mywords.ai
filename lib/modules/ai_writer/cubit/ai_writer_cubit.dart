import 'package:bloc/bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/ai_writer/repository/ai_writer_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'ai_writer_state.dart';

class AiWriterCubit extends Cubit<AiWriterState> {
  final AiWriterRepository _aiWriterRepository;

  AiWriterCubit({required AiWriterRepository aiWriterRepository})
      : _aiWriterRepository = aiWriterRepository,
        super(AiWriterState.initial());

  // Internal storage (does not affect UI)
  String _text = '';
  String _writingPurpose = '';
  String _writingLanguage = '';
  int _minWordLimit = 0;
  int _maxWordLimit = 0;

  void setText(String value) {
    _text = value;
  }

  void setWritingPurpose(String value) {
    _writingPurpose = value;
  }

  void setWritingLanguage(String value) {
    _writingLanguage = value;
  }

  void setMinWordLimit(int min) {
    _minWordLimit = min;
  }

  void setMaxWordLimit(int max) {
    _maxWordLimit = max;
  }

  Map<String, dynamic> getMap() {
    String token = sl<StorageService>().getString(AppKeys.token) ?? '';
    return {
      "text": _text,
      "writingPurpose": _writingPurpose.toLowerCase(),
      "writingLanguage": _writingLanguage,
      "minWordLimit": _minWordLimit,
      "maxWordLimit": _maxWordLimit,
      "token": token,
    };
  }

  void generateOutput() async {
    emit(state.copyWith(aiWriterStatus: AiWriterStatus.loading));
    final result = await _aiWriterRepository.generate(data: getMap());
    print('result is :: $result');

    result.handle(
      onSuccess: (String generatedText) async {
        emit(state.copyWith(aiWriterStatus: AiWriterStatus.success, generatedText: generatedText));
      },
      onError: (error) {
        emit(state.copyWith(aiWriterStatus: AiWriterStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }

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

  void reset() {
    // Reset internal fields
    _text = '';
    _writingPurpose = '';
    _writingLanguage = '';
    _minWordLimit = 0;
    _maxWordLimit = 0;

    // Reset state
    emit(AiWriterState.initial());
  }
}
