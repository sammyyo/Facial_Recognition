import 'dart:ui';

class Recognition {
  String label;
  double confidence;
  Rect location;
  String skinTone;
  String skinType;
  double overall;
  double potential;
  double jawline;
  double masculinity;
  double skinQuality;
  double cheekbones;

  Recognition({
    required this.label,
    required this.confidence,
    required this.location,
    required this.skinTone,
    required this.skinType,
    required this.overall,
    required this.potential,
    required this.jawline,
    required this.masculinity,
    required this.skinQuality,
    required this.cheekbones,
  });
}
