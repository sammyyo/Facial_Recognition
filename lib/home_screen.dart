import 'package:flutter/material.dart';
import 'pages/recognition_screen.dart';
import 'pages/registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.asset(
              "images/logo.png",
              width: screenWidth - 40,
              height: screenWidth - 40,
            ),
          ),
          const SizedBox(height: 20), // Spacing between image and buttons
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Register"),
                ),
                const SizedBox(height: 20), // Spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecognitionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Recognize"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
