import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:face_recognition/services/face_analysis_service.dart';
import 'package:face_recognition/components/face_analysis_chart.dart';

class FaceAnalysisPage extends StatelessWidget {
  final Map<String, double> faceScores;

  const FaceAnalysisPage({super.key, required this.faceScores});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Analysis"),
        backgroundColor: const Color.fromARGB(255, 59, 91, 146), // Optional: match your app theme
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Face Analysis",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Show face analysis chart with faceScores
            FaceAnalysisChart(faceScores: faceScores),
            const SizedBox(height: 20),
            
            // Button to proceed to recommendations
            ElevatedButton(
              onPressed: () {
                // Navigate to recommendations page
                Navigator.pushNamed(context, '/recommendations');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 59, 91, 146),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Get Recommendations",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
