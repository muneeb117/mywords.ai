import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileRepository {
  Future<bool> requestStoragePermission() async {
    // For Android 13+, we need to request specific permissions
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt < 29) {
        // Android 9 and below
        final status = await Permission.storage.request();
        return status.isGranted;
      } else {
        // Android 10 and above (Scoped Storage)
        // File picker doesn't need permission for SAF
        return true;
      }
    }
    return true; // iOS and others
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<String> extractTextFromPdf(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);

      StringBuffer fullText = StringBuffer();

      for (int i = 0; i < document.pages.count; i++) {
        String pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);
        fullText.writeln(pageText);
      }

      document.dispose();
      return normalizeExtractedText(fullText.toString());
    } catch (e) {
      return 'Error extracting text from PDF: ${e.toString()}';
    }
  }
  Future<String> extractTextFromDocFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final text = docxToText(bytes);
      return text;
    } catch (e) {
      return 'Error extracting text from PDF: ${e.toString()}';
    }
  }

  String normalizeExtractedText(String text) {
    // Replace multiple newlines or single newlines with space
    String cleaned = text.replaceAll(RegExp(r'\n+'), ' ');

    // Replace multiple spaces with a single space
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Optional: trim leading/trailing space
    return cleaned.trim();
  }
}
