import 'package:face_recognition/components/face_analysis_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';
import 'home_screen.dart';
import 'pages/recognition_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger
  final logger = Logger();

  // Firebase initialization with platform check
  try {
    if (defaultTargetPlatform != TargetPlatform.linux && !kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      logger.i('Firebase initialized successfully');
    } else {
      logger.i('Firebase skipped on Linux or Web');
    }
  } catch (e) {
    logger.e('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/recommendations': (context) => const RecognitionScreen(),
      },
    );
  }
}
