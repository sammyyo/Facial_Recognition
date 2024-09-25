
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class ImagePickerService {
  final ImagePicker imagePicker = ImagePicker();
  final FaceDetector faceDetector;

  ImagePickerService(this.faceDetector);

  Future<File?> pickImageFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickImageFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<img.Image?> decodeImage(File? file) async {
    if (file == null) return null;
    return img.decodeImage(file.readAsBytesSync());
  }

  Future<ui.Image?> convertToUiImage(img.Image image) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      image.getBytes(),
      image.width,
      image.height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) {
        completer.complete(img);
      },
    );
    return completer.future;
  }

  Future<List<Face>> detectFaces(File? file) async {
    if (file == null) return [];
    InputImage inputImage = InputImage.fromFile(file);
    return await faceDetector.processImage(inputImage);
  }

  void dispose() {
    faceDetector.close();
  }
}
