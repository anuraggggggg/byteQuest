import 'package:flutter/material.dart';
import '../../mascot/presentation/byte_mascot.dart';

export '../../mascot/presentation/byte_mascot.dart';

/// Legacy alias mapping CodieMood directly to ByteState
typedef CodieMood = ByteState;

/// Legacy CodieCompanion wrapper delegating to ByteMascot
class CodieCompanion extends StatelessWidget {
  final ByteState mood;
  final String? speechText;
  final VoidCallback? onTap;
  final double size;

  const CodieCompanion({
    super.key,
    required this.mood,
    this.speechText,
    this.onTap,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ByteMascot(
      state: mood,
      speechText: speechText,
      onTap: onTap,
      size: size,
    );
  }
}
