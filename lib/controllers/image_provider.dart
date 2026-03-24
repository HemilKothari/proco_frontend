import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobhub_v1/constants/app_constants.dart';

class ImageNotifier extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  bool isLoading = false;
  String? errorMessage;

  Future<void> pickImage() async {
    try {
      _setLoading(true);
      _clearError();

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (pickedFile == null) {
        _setLoading(false);
        return;
      }

      final XFile? croppedFile = await _cropImage(pickedFile);

      if (croppedFile == null) {
        _setLoading(false);
        return;
      }

      selectedImage = File(croppedFile.path);

      notifyListeners();
    } catch (e) {
      _setError('Something went wrong: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<XFile?> _cropImage(XFile imageFile) async {
    try {
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        maxHeight: 800,
        maxWidth: 600,
        compressQuality: 70,
        aspectRatioPresets: [CropAspectRatioPreset.ratio5x4],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color(kLightBlue.value),
            toolbarWidgetColor: Color(kLight.value),
            initAspectRatio: CropAspectRatioPreset.ratio5x4,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (cropped == null) return null;

      return XFile(cropped.path);
    } catch (e) {
      _setError('Cropping failed: ${e.toString()}');
      return null;
    }
  }

  void clearImage() {
    selectedImage = null;
    notifyListeners();
  }

  bool get hasImage => selectedImage != null;

  File? get imageFile => selectedImage;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    errorMessage = null;
  }
}
