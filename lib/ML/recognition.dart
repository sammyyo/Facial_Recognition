import 'dart:ui';

class Recognition {
  final String label;
  final double confidence;
  final Rect location;
  final String skinTone; // Add this
  final String skinType; // Add this

  Recognition({
    required this.label,
    required this.confidence,
    required this.location,
    required this.skinTone,
    required this.skinType,
  });
}
