import '/ML/recognition.dart';
import '/ML/recognizer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '/components/image_picker_service.dart';
import '/components/face_painter.dart';
import 'package:image/image.dart' as img;

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late ImagePickerService imagePickerService;
  File? _image;
  img.Image? decodedImage;
  ui.Image? uiImage;
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
    setState(() {
      isLoading = true;
    });

    File? image = await imagePickerService.pickImageFromCamera();

    if (!mounted) return; // Check if widget is mounted

    setState(() {
      _image = image;
      isLoading = false;
    });

    await _processImage();
  }

  Future<void> _processImage() async {
    decodedImage = await imagePickerService.decodeImage(_image);
    if (decodedImage == null) return;

    uiImage = await imagePickerService.convertToUiImage(decodedImage!);

    if (!mounted) return; // Check if widget is mounted

    // Detect faces and other processing logic...
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 91, 146),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
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
                  : Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('No image selected'),
                        ),
                      ),
                    ),
              if (isLoading)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Processing image, please wait...',
                        style: TextStyle(fontSize: 16)),
                  ],
                )
              else if (recommendedProducts.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: recommendedProducts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(recommendedProducts[index]),
                          subtitle: const Text('Based on your face analysis'),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: FloatingActionButton(
                onPressed: _pickImageFromCamera,
                backgroundColor: const Color.fromARGB(255, 59, 91, 146),
                child:
                    const Icon(Icons.camera_alt, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
