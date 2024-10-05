import 'package:flutter/material.dart';
import 'pages/recognition_screen.dart'; // Import recognition screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  bool isLoading = false;

  void navigateToRecognitionScreen() {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay for showing the loading indicator
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecognitionScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B5998), Color(0xFF192A56)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 100),
            Hero(
              tag: 'appLogo',
              child: Image.asset(
                "images/logo.png",
                width: screenWidth - 40,
                height: screenWidth - 40,
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: navigateToRecognitionScreen,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.7, 60),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: const Color.fromARGB(255, 59, 91, 146),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8, // Add shadow for button
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "Scan your face",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
