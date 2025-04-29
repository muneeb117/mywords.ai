part of 'file_import_cubit.dart';

enum FileImportStatus { initial, loading, success, failure }

class FileImportState {
  final FileImportStatus fileImportStatus;
  final String fileName;
  final String extractedText;
  final String errorMsg;

  FileImportState({required this.fileImportStatus, required this.fileName, required this.extractedText, required this.errorMsg});

  factory FileImportState.initial() {
    return FileImportState(fileImportStatus: FileImportStatus.initial, fileName: '', extractedText: '', errorMsg: '');
  }

  FileImportState copyWith({FileImportStatus? fileImportStatus, String? fileName, String? extractedText, String? errorMsg}) {
    return FileImportState(
      fileImportStatus: fileImportStatus ?? this.fileImportStatus,
      fileName: fileName ?? this.fileName,
      extractedText: extractedText ?? this.extractedText,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
