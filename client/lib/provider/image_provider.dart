import 'dart:io';

import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  final InitSheredPref _initSheredPref = InitSheredPref.instance;
  File? _imageFile;
  File? get imageFile => _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _initSheredPref.setImages(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _initSheredPref.setImages(pickedFile.path);
      notifyListeners();
    }
  }

  //get images
  Future<void> PickImage() async {
    final image = await _initSheredPref.getImages();
    _imageFile = File(image!);
    notifyListeners();
  }
}
