
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui; // For ui.Image from dart:ui
import 'package:face_recognition/components/image_picker_service.dart';
import 'package:face_recognition/components/face_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_recognition/ML/recognizer.dart';
import 'package:image/image.dart' as img; // For image processing

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late ImagePickerService imagePickerService;
  File? _image;
  img.Image? decodedImage; // For image processing
  ui.Image? uiImage; // For rendering with CustomPainter
  late Recognizer recognizer;

  List<Face> faces = [];

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
    faces = await imagePickerService.detectFaces(_image);

    setState(() {
      // Redraw with new data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          uiImage != null
              ? Container(
                  margin: const EdgeInsets.all(20),
                  child: CustomPaint(
                    painter: FacePainter(
                      recognitions: [], // Replace with the list of recognitions
                      imageFile: uiImage,
                    ),
                  ),
                )
              : const Center(child: Text('No image selected')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: _pickImageFromCamera,
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _pickImageFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
