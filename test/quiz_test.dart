import 'package:flutter_test/flutter_test.dart';
import 'package:byte_quest/features/quiz/domain/models/question_model.dart';
import 'package:byte_quest/features/quiz/data/mock_questions.dart';

void main() {
  group('Question Model & Data Integrity Tests', () {
    test('Question model should instantiate correctly with all required properties', () {
      const question = Question(
        id: 'test_q1',
        language: 'Dart',
        title: 'Sample Question',
        codeSnippet: 'print(42);',
        options: ['42', 'null', '0', 'Error'],
        correctOptionIndex: 0,
        explanation: '42 is printed to console.',
        hint: 'Direct integer print.',
      );

      expect(question.id, equals('test_q1'));
      expect(question.language, equals('Dart'));
      expect(question.options.length, equals(4));
      expect(question.correctOptionIndex, equals(0));
    });

    test('All quiz stages should have valid metadata and non-empty questions', () {
      expect(quizStages.isNotEmpty, isTrue);

      for (final stage in quizStages) {
        expect(stage.level, greaterThan(0));
        expect(stage.title.isNotEmpty, isTrue);
        expect(stage.subtitle.isNotEmpty, isTrue);
        expect(stage.description.isNotEmpty, isTrue);
        expect(stage.questions.isNotEmpty, isTrue);
      }
    });

    test('All mock questions across all stages should have valid data integrity', () {
      final seenIds = <String>{};

      for (final stage in quizStages) {
        for (final question in stage.questions) {
          // Check unique ID
          expect(
            seenIds.contains(question.id),
            isFalse,
            reason: 'Duplicate question ID found: ${question.id}',
          );
          seenIds.add(question.id);

          // Check options and correct index bounds
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(
            question.correctOptionIndex,
            greaterThanOrEqualTo(0),
            reason: 'Question ${question.id} has negative correctOptionIndex',
          );
          expect(
            question.correctOptionIndex,
            lessThan(question.options.length),
            reason: 'Question ${question.id} correctOptionIndex exceeds options length',
          );

          // Check string fields are not blank
          expect(question.title.trim().isNotEmpty, isTrue);
          expect(question.codeSnippet.trim().isNotEmpty, isTrue);
          expect(question.explanation.trim().isNotEmpty, isTrue);
          expect(question.hint.trim().isNotEmpty, isTrue);
        }
      }
    });
  });
}
