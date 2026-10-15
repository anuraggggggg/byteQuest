import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/question_model.dart';

class QuizStage {
  final int level;
  final String title;
  final String subtitle;
  final String description;
  final String iconEmoji;
  final Color accentColor;
  final List<Question> questions;

  const QuizStage({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconEmoji,
    required this.accentColor,
    required this.questions,
  });
}

// -------------------------------------------------------------
// STAGE 1: BEGINNER DEV (Syntax & Variables)
// -------------------------------------------------------------
final List<Question> level1Questions = [
  const Question(
    id: 'l1_q1',
    language: 'Python',
    title: 'List Comprehension Basics',
    codeSnippet: '''numbers = [1, 2, 3, 4, 5]
squares = [x ** 2 for x in numbers if x % 2 != 0]
print(squares)''',
    options: [
      '[1, 4, 9, 16, 25]',
      '[1, 9, 25]',
      '[4, 16]',
      '[1, 3, 5]',
    ],
    correctOptionIndex: 1,
    explanation: 'List comprehension filters odd numbers (1, 3, 5) and squares them (1, 9, 25).',
    hint: 'Check the condition x % 2 != 0! Only odd numbers are squared.',
  ),
  const Question(
    id: 'l1_q2',
    language: 'JavaScript',
    title: 'Block Scope with Let vs Var',
    codeSnippet: '''for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 10);
}''',
    options: [
      '0, 1, 2',
      '3, 3, 3',
      'undefined, undefined, undefined',
      '0, 0, 0',
    ],
    correctOptionIndex: 1,
    explanation: 'var is function-scoped. By the time setTimeout executes, the loop finished and i is 3.',
    hint: 'var does not create block scope in loops! Use let for block scope.',
  ),
  const Question(
    id: 'l1_q3',
    language: 'Dart',
    title: 'String Interpolation',
    codeSnippet: '''void main() {
  String name = 'ByteQuest';
  print('Welcome to \${name.toUpperCase()}!');
}''',
    options: [
      'Welcome to ByteQuest!',
      'Welcome to BYTEQUEST!',
      'Welcome to \${name.toUpperCase()}!',
      'Error: Invalid Syntax',
    ],
    correctOptionIndex: 1,
    explanation: '\${expression} evaluates Dart expressions inside string literals.',
    hint: 'toUpperCase() converts string characters to uppercase!',
  ),
];

// -------------------------------------------------------------
// STAGE 2: INTERMEDIATE CODER (Control Flow & Async)
// -------------------------------------------------------------
final List<Question> level2Questions = [
  const Question(
    id: 'l2_q1',
    language: 'JavaScript',
    title: 'Async Event Loop & Microtasks',
    codeSnippet: '''console.log('1');
setTimeout(() => console.log('2'), 0);
Promise.resolve().then(() => console.log('3'));
console.log('4');''',
    options: [
      '1, 2, 3, 4',
      '1, 4, 2, 3',
      '1, 4, 3, 2',
      '4, 1, 3, 2',
    ],
    correctOptionIndex: 2,
    explanation: 'Synchronous code (1, 4) executes first, followed by microtasks (Promise -> 3), then macrotasks (setTimeout -> 2).',
    hint: 'Microtasks (Promises) run before Macrotasks (setTimeout)!',
  ),
  const Question(
    id: 'l2_q2',
    language: 'Dart',
    title: 'Null Safety & Cascade Operator',
    codeSnippet: '''class ByteBot {
  String? name;
  void greet() => print('Hello \$name');
}

void main() {
  final bot = ByteBot()..name = 'Cyber'..greet();
}''',
    options: [
      'Hello null',
      'Hello Cyber',
      'Compilation Error',
      'Null Pointer Exception',
    ],
    correctOptionIndex: 1,
    explanation: 'The cascade operator (..) assigns "Cyber" to name first, then invokes greet() on the same object.',
    hint: 'Cascade operator (..) allows chaining calls on the same instance sequentially!',
  ),
  const Question(
    id: 'l2_q3',
    language: 'Python',
    title: 'Decorator Execution Flow',
    codeSnippet: '''def my_decorator(func):
    def wrapper():
        print("Before")
        func()
        print("After")
    return wrapper

@my_decorator
def say_hello():
    print("Hello!")

say_hello()''',
    options: [
      'Hello!\nBefore\nAfter',
      'Before\nHello!\nAfter',
      'Before\nAfter\nHello!',
      'Compilation Error',
    ],
    correctOptionIndex: 1,
    explanation: 'The decorator wraps say_hello(), printing "Before", then executing func(), then "After".',
    hint: 'Decorators wrap the inner target function execution!',
  ),
];

// -------------------------------------------------------------
// STAGE 3: ADVANCED ARCHITECT (OOP & Concurrency)
// -------------------------------------------------------------
final List<Question> level3Questions = [
  const Question(
    id: 'l3_q1',
    language: 'Dart',
    title: 'Isolate Message Passing',
    codeSnippet: '''import 'dart:isolate';

void isolateEntry(SendPort sendPort) {
  sendPort.send('Data Processed');
}

void main() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(isolateEntry, receivePort.sendPort);
  final message = await receivePort.first;
  print(message);
}''',
    options: [
      'Data Processed',
      'Instance of SendPort',
      'Null',
      'Unhandled Exception',
    ],
    correctOptionIndex: 0,
    explanation: 'Dart Isolates do not share memory; they communicate by passing messages over Ports.',
    hint: 'Isolates communicate by sending messages via SendPort/ReceivePort!',
  ),
  const Question(
    id: 'l3_q2',
    language: 'JavaScript',
    title: 'Closure Lexical Environment',
    codeSnippet: '''function outer() {
  let count = 0;
  return function inner() {
    count++;
    return count;
  };
}

const counter1 = outer();
const counter2 = outer();
counter1();
print(counter1() + counter2());''',
    options: [
      '3',
      '4',
      '2',
      'NaN',
    ],
    correctOptionIndex: 0,
    explanation: 'counter1() increments its closure count to 2. counter2() creates a separate closure count starting at 1. 2 + 1 = 3.',
    hint: 'Each invocation of outer() creates a distinct closure environment!',
  ),
  const Question(
    id: 'l3_q3',
    language: 'Python',
    title: 'Generator Delegating Yield From',
    codeSnippet: '''def subgen():
    yield 10
    yield 20

def main_gen():
    yield 1
    yield from subgen()
    yield 2

print(list(main_gen()))''',
    options: [
      '[1, 10, 20, 2]',
      '[1, [10, 20], 2]',
      '[1, 2, 10, 20]',
      'SyntaxError',
    ],
    correctOptionIndex: 0,
    explanation: 'yield from delegates generator iteration to subgen(), flattening its yielded elements.',
    hint: 'yield from delegates to another generator directly!',
  ),
  const Question(
    id: 'l3_q4',
    language: 'Dart',
    title: 'Dart 3 Pattern Matching & Records',
    codeSnippet: '''var (a, [b, c]) = ('Byte', [2, 4]);
switch ((a, b + c)) {
  case ('Byte', > 5):
    print('Quest Master');
  case ('Byte', _):
    print('Quest Initiate');
  default:
    print('Unknown');
}''',
    options: [
      'Quest Master',
      'Quest Initiate',
      'Unknown',
      'Compile Error',
    ],
    correctOptionIndex: 0,
    explanation: 'b + c evaluates to 2 + 4 = 6. In the switch statement, the record matches the first case where a == "Byte" and 6 > 5.',
    hint: 'Evaluate b + c, then test the relational pattern > 5!',
  ),
];

// All Stages definitions
final List<QuizStage> quizStages = [
  QuizStage(
    level: 1,
    title: 'Stage 1: Beginner Dev',
    subtitle: 'Syntax & Variables',
    description: 'Master core language syntax, list operations, and basic scope rules.',
    iconEmoji: '🟢',
    accentColor: AppColors.successGreen,
    questions: level1Questions,
  ),
  QuizStage(
    level: 2,
    title: 'Stage 2: Intermediate Coder',
    subtitle: 'Control Flow & Async',
    description: 'Conquer async event loops, microtasks, null-safety, and function decorators.',
    iconEmoji: '🔵',
    accentColor: AppColors.primaryAccent,
    questions: level2Questions,
  ),
  QuizStage(
    level: 3,
    title: 'Stage 3: Advanced Architect',
    subtitle: 'Concurrency & Memory',
    description: 'Tackle Dart isolates, closures, generator delegation, and memory patterns.',
    iconEmoji: '🟣',
    accentColor: AppColors.comboAccent,
    questions: level3Questions,
  ),
];

final List<Question> mockQuestions = level1Questions;
