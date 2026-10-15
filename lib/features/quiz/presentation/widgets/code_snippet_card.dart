import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CodeSnippetCard extends StatelessWidget {
  final String language;
  final String title;
  final String codeSnippet;

  const CodeSnippetCard({
    super.key,
    required this.language,
    required this.title,
    required this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.codeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IDE Window Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // macOS style window dots
                Row(
                  children: [
                    _buildDot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 6),
                    _buildDot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 6),
                    _buildDot(const Color(0xFF27C93F)),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Language Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    language.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Code Content Box with line numbers
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildSyntaxHighlightedCode(codeSnippet),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSyntaxHighlightedCode(String code) {
    final lines = code.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines.length, (index) {
        final lineNum = index + 1;
        final lineText = lines[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line Number
              SizedBox(
                width: 24,
                child: Text(
                  '$lineNum',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Code Line with syntax highlight text
              RichText(
                text: TextSpan(
                  children: _highlightLine(lineText),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<TextSpan> _highlightLine(String line) {
    final List<TextSpan> spans = [];

    // Keywords syntax highlighting
    final keywords = [
      'def', 'class', 'import', 'from', 'return', 'if', 'else', 'for', 'in',
      'print', 'const', 'final', 'var', 'let', 'void', 'function', 'new',
      'Promise', 'resolve', 'async', 'await', 'String', 'int', 'bool'
    ];

    final words = line.split(RegExp(r'(\s+|[(),.:;={}\[\]])'));
    int lastIdx = 0;

    for (final word in words) {
      if (word.isEmpty) continue;
      final idx = line.indexOf(word, lastIdx);
      if (idx > lastIdx) {
        spans.add(TextSpan(
          text: line.substring(lastIdx, idx),
          style: const TextStyle(color: AppColors.textPrimary),
        ));
      }

      Color color = AppColors.textPrimary;

      if (keywords.contains(word)) {
        color = const Color(0xFFFF79C6); // Keyword Pink
      } else if (RegExp(r'^\d+$').hasMatch(word)) {
        color = const Color(0xFFBD93F9); // Number Purple
      } else if (word.startsWith("'") || word.startsWith('"') || word.endsWith("'") || word.endsWith('"')) {
        color = const Color(0xFFF1FA8C); // String Yellow
      } else if (word.contains('=>') || word == 'print' || word == 'console.log') {
        color = const Color(0xFF50FA7B); // Function Green
      } else if (word.startsWith('ByteBot') || word.startsWith('Promise')) {
        color = const Color(0xFF8BE9FD); // Cyan type
      }

      spans.add(TextSpan(
        text: word,
        style: TextStyle(
          color: color,
          fontWeight: keywords.contains(word) ? FontWeight.bold : FontWeight.normal,
        ),
      ));

      lastIdx = idx + word.length;
    }

    if (lastIdx < line.length) {
      spans.add(TextSpan(
        text: line.substring(lastIdx),
        style: const TextStyle(color: AppColors.textPrimary),
      ));
    }

    return spans;
  }
}
