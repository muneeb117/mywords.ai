import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart' show AnalyticsEventNames;
import 'package:mywords/core/analytics/analytics_service.dart' show AnalyticsService;
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/ai_humanizer/repository/ai_humanizer_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'ai_humanize_state.dart';

class AiHumanizerCubit extends Cubit<AiHumanizerState> {
  final AiHumanizerRepository _aiHumanizerRepository;
  final AnalyticsService _analyticsService;
  String _text = '';
  String _promptType = ''; // file/text
  String _fileName = ''; // uploadedFile ? uploadedFile.name : ""

  AiHumanizerCubit({
    required AiHumanizerRepository aiHumanizerRepository,
    required AnalyticsService analyticsService,
  }) : _aiHumanizerRepository = aiHumanizerRepository,
       _analyticsService = analyticsService,

       super(AiHumanizerState.initial());

  void setText(String value) {
    _text = value;
  }

  void setPromptType(String value) {
    _promptType = value;
  }

  void setFileName(String value) {
    _fileName = value;
  }

  void humanizeText({required bool isPremium}) async {
    emit(state.copyWith(aiHumanizeStatus: AiHumanizeStatus.loading));
    final result = await _aiHumanizerRepository.humanize(data: _getMap(isPremium));
    log('API REQUEST data :: ${_getMap(isPremium)}');
    print('result is :: $result');

    result.handle(
      onSuccess: (String generatedText) async {
        int wordCount = countWords(generatedText);
        _analyticsService.logEvent(name: AnalyticsEventNames.aiHumanizerSuccess);

        emit(
          state.copyWith(
            aiHumanizeStatus: AiHumanizeStatus.success,
            generatedText: generatedText,
            generatedOutputWordCount: wordCount,
          ),
        );
      },
      onError: (error) {
        _analyticsService.logEvent(name: AnalyticsEventNames.aiHumanizerFailed);
        emit(state.copyWith(aiHumanizeStatus: AiHumanizeStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }

  void saveUserPrompt() async {
    final result = await _aiHumanizerRepository.saveHumanizerPromptData(data: _getPromptData());
    print('result is :: $result');

    result.handle(onSuccess: (result) async {}, onError: (error) {});
  }

  Map<String, dynamic> _getMap(bool isPremium) {
    String token = sl<StorageService>().getString(AppKeys.token) ?? '';


    return {"text": _text, "token": token, 'isPremium': isPremium};


  }

  Map<String, dynamic> _getPromptData() {
    return {
      "prompt": _text,
      "prompt_type": _promptType,
      "filename": _fileName,
      "method": 'humanizer',
      "response": state.generatedText,
    };
  }

  void updateText(String value) {
    int wordCount = countWords(value);
    emit(
      state.copyWith(text: value, wordCount: wordCount, aiHumanizeStatus: AiHumanizeStatus.initial),
    );
  }

  int countWords(String text) {
    return text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  }

  void reset() {
    _text = '';
    _promptType = '';
    _fileName = '';
    emit(AiHumanizerState.initial());
  }
}
