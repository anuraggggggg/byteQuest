# Contributing to ByteQuest

Thank you for your interest in contributing to **ByteQuest**! We welcome community contributions, improvements, bug reports, and feedback.

---

## 🧭 Code of Conduct

Please review and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) in all community interactions and contributions.

---

## 🛠️ How to Contribute

### 1. Reporting Bugs
- Use the [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.yml).
- Include steps to reproduce, expected vs. actual behavior, and relevant device logs.

### 2. Suggesting Features
- Open an issue using the [Feature Request Template](.github/ISSUE_TEMPLATE/feature_request.yml).
- Explain the context, motivation, and proposed user experience.

### 3. Submitting Pull Requests
1. **Fork** the repository and clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/byteQuest.git
   cd byteQuest
   ```
2. **Create a topic branch**:
   ```bash
   git checkout -b feature/awesome-quiz-topic
   # or
   git checkout -b fix/issue-description
   ```
3. **Make your changes**:
   - Write clean, well-commented code.
   - Follow Flutter and Dart style guides.
4. **Format & Analyze**:
   ```bash
   dart format .
   flutter analyze
   flutter test
   ```
5. **Commit and Push**:
   ```bash
   git commit -m "feat(quiz): add async stream challenges"
   git push origin feature/awesome-quiz-topic
   ```
6. **Open a Pull Request** against the `main` branch.

---

## 📐 Coding Conventions

- Follow the [Effective Dart](https://dart.dev/effective-dart) guidelines.
- Prefer `const` constructors wherever possible.
- Avoid placing business logic directly inside build methods.
- Document public APIs and complex algorithms.
