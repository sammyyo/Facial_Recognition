import 'dart:ui' as ui;
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_recognition/ML/recognition.dart';

class FacePainter extends CustomPainter {
  final List<Recognition> recognitions;
  final ui.Image? imageFile;

  FacePainter({required this.recognitions, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile!, Offset.zero, Paint());
    }

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (Recognition recognition in recognitions) {
      canvas.drawRect(recognition.location, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.recognitions != recognitions || oldDelegate.imageFile != imageFile;
  }
}
