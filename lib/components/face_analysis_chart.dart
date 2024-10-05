import 'package:fl_chart/fl_chart.dart'
    show
        FlBorderData,
        RadarChart,
        RadarChartData,
        RadarDataSet,
        RadarEntry,
        RadarTouchData,
        RadarChartTitle;  // Add this import
import 'package:flutter/material.dart';

class FaceAnalysisChart extends StatelessWidget {
  final Map<String, double> faceScores;

  const FaceAnalysisChart({super.key, required this.faceScores});

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarTouchData: RadarTouchData(enabled: true),
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withOpacity(0.3),
            borderColor: Colors.blue,
            entryRadius: 3,
            dataEntries: faceScores.entries
                .map((e) => RadarEntry(value: e.value))
                .toList(),
          )
        ],
        borderData: FlBorderData(show: true),
        radarBackgroundColor: Colors.transparent,
        titlePositionPercentageOffset: 0.2,
        getTitle: (index, angle) {
          // Wrap the string in a RadarChartTitle object
          return RadarChartTitle(
            text: faceScores.keys.elementAt(index),
            angle: angle,
          );
        },
      ),
    );
  }
}