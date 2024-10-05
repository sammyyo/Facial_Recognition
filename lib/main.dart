import 'package:face_recognition/pages/face_analysis_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'home_screen.dart';
import 'pages/recognition_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger
  final logger = Logger();

  // Firebase initialization inside try-catch block
  try {
    await Firebase.initializeApp();
    logger
        .i('Firebase initialized successfully'); // Use logger instead of print
  } catch (e) {
    // Log error if Firebase fails to initialize
    logger
        .e('Error initializing Firebase: $e'); // Use logger for error handling
  }

  runApp(const MyApp()); // Ensure const MyApp is used
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'ShafN',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/face_analysis': (context) => FaceAnalysisPage(faceScores: {}),
        '/recommendations': (context) =>
            const RecognitionScreen(), // Corrected to RecognitionScreen
      },
    );
  }
}
