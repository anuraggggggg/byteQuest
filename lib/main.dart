import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/quiz/presentation/splash_screen.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ByteQuestApp());
}

class ByteQuestApp extends StatelessWidget {
  const ByteQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byte Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const LoginScreen(),
      },
    );
  }
}
