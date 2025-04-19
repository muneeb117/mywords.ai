import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mywords/core/repository/file_repository.dart';

part 'file_import_state.dart';

class FileImportCubit extends Cubit<FileImportState> {
  final FileRepository _fileRepository;

  FileImportCubit({required FileRepository fileRepository})
      : _fileRepository = fileRepository,
        super(FileImportState.initial());

  Future<void> importFile() async {
    emit(state.copyWith(fileImportStatus: FileImportStatus.loading));

    try {
      bool hasPermission = await _fileRepository.requestStoragePermission();
      if (!hasPermission) {
        emit(state.copyWith(fileImportStatus: FileImportStatus.failure, errorMsg: 'Permission Required'));
        return;
      }

      File? file = await _fileRepository.pickFile();
      if (file == null) {
        emit(state.copyWith(fileImportStatus: FileImportStatus.initial));
        return;
      }

      String filePath = file.path.toLowerCase();
      final fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
      String extractedText = '';

      if (filePath.endsWith('.pdf')) {
        extractedText = await _fileRepository.extractTextFromPdf(file);
      } else if (filePath.endsWith('.docx')) {
        extractedText = await _fileRepository.extractTextFromDocFile(file);
      } else {
        extractedText = 'Unsupported file format';
      }
      emit(state.copyWith(
        fileImportStatus: FileImportStatus.success,
        extractedText: extractedText,
        fileName: fileName,
      ));
    } catch (e) {
      emit(state.copyWith(fileImportStatus: FileImportStatus.failure, errorMsg: e.toString()));
    }
  }

  void reset() {
    emit(FileImportState.initial());
  }
}
