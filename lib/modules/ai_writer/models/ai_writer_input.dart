class AiWriterInput {
  final String text;
  final String writingPurpose;
  final String writingLanguage;
  final int minWordLimit;
  final int maxWordLimit;
  final String token;

  AiWriterInput({
    required this.text,
    required this.writingPurpose,
    required this.writingLanguage,
    required this.minWordLimit,
    required this.maxWordLimit,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'writingPurpose': writingPurpose,
    'writingLanguage': writingLanguage,
    'minWordLimit': minWordLimit,
    'maxWordLimit': maxWordLimit,
    'token': token,
  };
}