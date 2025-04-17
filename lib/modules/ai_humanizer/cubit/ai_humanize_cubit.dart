import 'package:bloc/bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/ai_humanizer/repository/ai_humanizer_repository.dart';

import 'package:mywords/utils/extensions/either_extension.dart';

part 'ai_humanize_state.dart';

class AiHumanizerCubit extends Cubit<AiHumanizerState> {
  final AiHumanizerRepository _aiHumanizerRepository;

  AiHumanizerCubit({required AiHumanizerRepository aiHumanizerRepository})
      : _aiHumanizerRepository = aiHumanizerRepository,
        super(AiHumanizerState.initial());

  String _text = '';

  void setText(String value) {
    _text = value;
  }

  Map<String, dynamic> getMap() {
    String token = sl<StorageService>().getString(AppKeys.token) ?? '';
    return {
      "text": _text,
      "isProEngine": false,
      "token": token,
    };
  }

  void humanizeText() async {
    emit(state.copyWith(aiHumanizeStatus: AiHumanizeStatus.loading));
    final result = await _aiHumanizerRepository.humanize(data: getMap());
    print('result is :: $result');

    result.handle(
      onSuccess: (String generatedText) async {
        int wordCount = countWords(generatedText);
        emit(state.copyWith(
          aiHumanizeStatus: AiHumanizeStatus.success,
          generatedText: generatedText,
          generatedOutputWordCount: wordCount,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          aiHumanizeStatus: AiHumanizeStatus.failed,
          errorMsg: error.errorMsg,
        ));
      },
    );
  }

  void updateText(String value) {
    int wordCount = countWords(value);
    emit(state.copyWith(
      text: value,
      wordCount: wordCount,
      aiHumanizeStatus: AiHumanizeStatus.initial,
    ));
  }

  int countWords(String text) {
    return text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  }

  void reset() {
    // Reset internal fields
    _text = '';
    // Reset state
    emit(AiHumanizerState.initial());
  }
}
