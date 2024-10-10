import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import '/components/image_picker_service.dart';
import '/components/face_painter.dart';
import '/ML/recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late ImagePickerService imagePickerService;
  late FaceDetector faceDetector;
  CameraController? _cameraController;
  bool isProcessing = false;
  List<Recognition> recognitions = [];
  bool isLoading = false;
  ui.Image? _uiImage;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _requestCameraPermission();

    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableClassification: true,
      enableTracking: true,
    );
    faceDetector = FaceDetector(options: options);
    imagePickerService = ImagePickerService(faceDetector);

    await _initializeCamera();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      logger.i('Camera permission granted');
    } else {
      logger.w('Camera permission denied');
      openAppSettings();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras.first, ResolutionPreset.medium);
      await _cameraController?.initialize();
      logger.i('Camera initialized successfully');

      int frameCount = 0;
      _cameraController?.startImageStream((CameraImage image) async {
        frameCount++;
        if (frameCount % 30 == 0) {  // Process every 30th frame
          if (!isProcessing) {
            isProcessing = true;
            logger.i('Starting image stream processing');

            try {
              final inputImage = _convertCameraImageToInputImage(image);
              final List<Face> detectedFaces = await faceDetector.processImage(inputImage);
              logger.i('Detected ${detectedFaces.length} faces');

              setState(() {
                recognitions = detectedFaces.map((face) {
                  return Recognition(
                    label: 'Unknown',
                    confidence: 0.5,
                    location: face.boundingBox,
                    skinTone: 'Neutral',
                    skinType: 'Normal',
                    overall: 0.8,
                    potential: 0.9,
                    jawline: 0.7,
                    cheekbones: 0.8,
                    masculinity: 0.6,
                    skinQuality: 0.7,
                  );
                }).toList();
                logger.i('Updated UI with ${recognitions.length} recognitions');
              });
            } catch (e) {
              logger.e('Error processing image: $e');
            } finally {
              isProcessing = false;
              logger.i('Finished processing image frame');
            }
          }
        }
      });

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      logger.e('Error initializing camera: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    setState(() => isLoading = true);

    try {
      File? imageFile = await imagePickerService.pickImageFromCamera();

      if (imageFile != null) {
        final inputImage = InputImage.fromFile(imageFile);
        final List<Face> detectedFaces = await faceDetector.processImage(inputImage);
        logger.i('Detected ${detectedFaces.length} faces in picked image');

        setState(() {
          recognitions = detectedFaces.map((face) {
            return Recognition(
              label: 'Unknown',
              confidence: 0.5,
              location: face.boundingBox,
              skinTone: 'Neutral',
              skinType: 'Normal',
              overall: 0.8,
              potential: 0.9,
              jawline: 0.7,
              cheekbones: 0.8,
              masculinity: 0.6,
              skinQuality: 0.7,
            );
          }).toList();
        });
      }
    } catch (e) {
      logger.e('Error picking image from camera: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputImage _convertCameraImageToInputImage(CameraImage image) {
    final allBytes = Uint8List(image.planes.fold(0, (acc, plane) => acc + plane.bytes.length));
    int offset = 0;
    for (Plane plane in image.planes) {
      allBytes.setRange(offset, offset + plane.bytes.length, plane.bytes);
      offset += plane.bytes.length;
    }

    final InputImageFormat inputFormat = image.format.raw == 35
        ? InputImageFormat.yuv420
        : InputImageFormat.bgra8888;

    final inputImageData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation90deg, // Adjust based on device orientation
      format: inputFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: allBytes,
      metadata: inputImageData,
    );
  }

  @override
  void dispose() {
    imagePickerService.dispose();
    _cameraController?.dispose();
    faceDetector.close();
    super.dispose();
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
              if (_cameraController != null && _cameraController!.value.isInitialized)
                Expanded(child: CameraPreview(_cameraController!))
              else if (_cameraController == null)
                const Center(child: Text('Error initializing camera. Please restart the app.'))
              else
                const Center(child: CircularProgressIndicator()),

              if (isProcessing)
                const Center(child: CircularProgressIndicator())
              else if (recognitions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(20),
                  child: FittedBox(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenWidth * 0.9,
                      child: CustomPaint(
                        painter: FacePainter(
                          recognitions: recognitions,
                          imageFile: _uiImage,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'No faces detected. Please ensure your face is visible and well-lit.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              if (recognitions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: FloatingActionButton(
                    onPressed: _pickImageFromCamera,
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}