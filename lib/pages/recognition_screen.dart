import 'package:flutter/material.dart';
import 'package:face_recognition/ML/recognition.dart';
import 'dart:io';
import 'dart:ui' as ui; // For ui.Image from dart:ui
import 'package:face_recognition/components/image_picker_service.dart';
import 'package:face_recognition/components/face_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_recognition/ML/recognizer.dart';
import 'package:image/image.dart' as img; // For image processing
import 'services/recommendation_service.dart'; // Import the service

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late ImagePickerService imagePickerService;
  File? _image;
  img.Image? decodedImage; // For image processing
  ui.Image? uiImage; // For rendering with CustomPainter
  late Recognizer recognizer;

  List<Recognition> recognitions = [];
  List<String> recommendedProducts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final options =
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    FaceDetector faceDetector = FaceDetector(options: options);
    imagePickerService = ImagePickerService(faceDetector);
    recognizer = Recognizer();
  }

  @override
  void dispose() {
    imagePickerService.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    File? image = await imagePickerService.pickImageFromCamera();
    if (image != null) {
      setState(() => _image = image);
      _processImage();
    }
  }

  Future<void> _pickImageFromGallery() async {
    File? image = await imagePickerService.pickImageFromGallery();
    if (image != null) {
      setState(() => _image = image);
      _processImage();
    }
  }

  Future<void> _processImage() async {
    decodedImage = await imagePickerService.decodeImage(_image);
    if (decodedImage == null) return;

    uiImage = await imagePickerService.convertToUiImage(decodedImage!);
    List<Face> faces = await imagePickerService.detectFaces(_image);

    recognitions.clear();
    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      Recognition recognition =
          recognizer.recognize(decodedImage!, boundingBox);
      recognitions.add(recognition);
    }

    setState(() {
      // After detecting faces, fetch beauty product recommendations
      _getRecommendations();
    });
  }

  Future<void> _getRecommendations() async {
    if (recognitions.isEmpty) {
      // No recognitions found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No faces detected for recommendations.")),
      );
      return;
    }

    // For simplicity, assume the first recognized face's attributes
    // You can extend this to handle multiple faces
    Recognition firstRecognition = recognitions.first;
    String skinTone =
        firstRecognition.skinTone; // Ensure your Recognition class has this
    String skinType =
        firstRecognition.skinType; // Ensure your Recognition class has this

    setState(() {
      isLoading = true;
    });

    RecommendationService recommendationService = RecommendationService();
    List<String> recommendations =
        await recommendationService.getRecommendations(skinTone, skinType);

    setState(() {
      recommendedProducts = recommendations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Face Recognition'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          uiImage != null
              ? Container(
                  margin: const EdgeInsets.all(20),
                  child: FittedBox(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenWidth * 0.9,
                      child: CustomPaint(
                        painter: FacePainter(
                          recognitions: recognitions,
                          imageFile: uiImage,
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('No image selected')),
          isLoading
              ? const CircularProgressIndicator()
              : recommendedProducts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: recommendedProducts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.check),
                            title: Text(recommendedProducts[index]),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: _pickImageFromCamera,
                iconSize: 40,
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _pickImageFromGallery,
                iconSize: 40,
              ),
            ],
          ),
          const SizedBox(height: 20), // Add some spacing at the bottom
        ],
      ),
    );
  }
}
