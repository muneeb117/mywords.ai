import 'package:bloc/bloc.dart';
import 'package:mywords/modules/ai_writer/models/ai_writer_input.dart';
import 'package:mywords/modules/ai_writer/repository/ai_writer_repository.dart';
import 'package:mywords/utils/extensions/either_extension.dart';

part 'ai_writer_state.dart';

class AiWriterCubit extends Cubit<AiWriterState> {
  AiWriterCubit({required AiWriterRepository aiWriterRepository})
      : _aiWriterRepository = aiWriterRepository,
        super(AiWriterState.initial());

  final AiWriterRepository _aiWriterRepository;

  // curl -X POST https://your-api-endpoint \
  //   -H "Content-Type: application/json" \
  //   -d '{
  //     "text": "The impact of AI on education",
  //     "token": "your_jwt_token",
  //     "writingPurpose": "essay",
  //     "writingLanguage": "English",
  //     "minWordLimit": 200,
  //     "maxWordLimit": 300
  //   }'

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

  void aiWriterApi(AiWriterInput aiWriterInput) async{
    emit(state.copyWith(aiWriterStatus: AiWriterStatus.loading));
    final result = await _aiWriterRepository.write(aiWriterInput);

    result.handle(
      onSuccess: (String token) async {
        emit(state.copyWith(aiWriterStatus: AiWriterStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(aiWriterStatus: AiWriterStatus.failed, errorMsg: error.errorMsg));
      },
    );
  }
}
