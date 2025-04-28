import 'package:bloc/bloc.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/analytics/analytics_event_names.dart' show AnalyticsEventNames;
import 'package:mywords/core/analytics/analytics_service.dart' show AnalyticsService;
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/ai_detector/models/ai_detector_entity.dart';
import 'package:mywords/modules/ai_detector/repository/ai_detector_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'ai_detector_state.dart';

class AiDetectorCubit extends Cubit<AiDetectorState> {
  final AiDetectorRepository _aiDetectorRepository;
  final AnalyticsService _analyticsService;

  AiDetectorCubit({required AiDetectorRepository aiDetectorRepository, required AnalyticsService analyticsService})
    : _aiDetectorRepository = aiDetectorRepository,
      _analyticsService = analyticsService,

      super(AiDetectorState.initial());

  String _text = '';

  void setText(String value) {
    _text = value;
  }

  void setPreference(String preference) {
    emit(state.copyWith(modelPreference: preference));
  }

  Map<String, dynamic> _getMap() {
    String token = sl<StorageService>().getString(AppKeys.token) ?? '';
    return {"text": _text, "isProEngine": false, "token": token};
  }

  void detectText() async {
    emit(state.copyWith(aiDetectorStatus: AiDetectorStatus.loading));
    final result = await _aiDetectorRepository.detect(data: _getMap());
    print('result is :: $result');

    result.handle(
      onSuccess: (AiDetectorEntity result) async {
        _analyticsService.logEvent(name: AnalyticsEventNames.aiDetectorSuccess);
        emit(state.copyWith(aiDetectorStatus: AiDetectorStatus.success, inputText: _text, aiDetectorEntity: result));
      },
      onError: (error) {
        _analyticsService.logEvent(name: AnalyticsEventNames.aiDetectorFailed);
        emit(state.copyWith(aiDetectorStatus: AiDetectorStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }

  void updateText(String value) {
    int wordCount = countWords(value);
    emit(state.copyWith(inputText: value, wordCount: wordCount, aiDetectorStatus: AiDetectorStatus.initial));
  }

  int countWords(String text) {
    return text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  }

  void reset() {
    _text = '';
    emit(AiDetectorState.initial());
  }
}
