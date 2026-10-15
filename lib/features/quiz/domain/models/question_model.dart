class Question {
  final String id;
  final String language;
  final String title;
  final String codeSnippet;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String hint;

  const Question({
    required this.id,
    required this.language,
    required this.title,
    required this.codeSnippet,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.hint,
  });
}
