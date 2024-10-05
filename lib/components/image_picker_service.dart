import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImagePickerService {
  final FaceDetector faceDetector;

  ImagePickerService(this.faceDetector);

  Future<File?> pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future<img.Image?> decodeImage(File? imageFile) async {
    if (imageFile == null) return null;
    final imageBytes = await imageFile.readAsBytes();
    return img.decodeImage(imageBytes);
  }

  Future<ui.Image> convertToUiImage(img.Image decodedImage) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      decodedImage.getBytes(),
      decodedImage.width,
      decodedImage.height,
      ui.PixelFormat.rgba8888,
      (uiImage) {
        completer.complete(uiImage);
      },
    );
    return completer.future;
  }

  Future<List<Face>> detectFaces(File? imageFile) async {
    if (imageFile == null) return [];
    final inputImage = InputImage.fromFile(imageFile);
    return await faceDetector.processImage(inputImage);
  }

  void dispose() {
    faceDetector.close();
  }
}
