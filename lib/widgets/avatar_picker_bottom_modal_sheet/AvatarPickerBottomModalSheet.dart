import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

SizedBox buildAvatarPickerBottomModalSheet(
    BuildContext context, ValueNotifier<File?> image) {
  ImagePicker picker = ImagePicker();

  double WIDTH = MediaQuery.of(context).size.width;

  closeModal() {
    Navigator.pop(context);
  }

  pickFromGallery() async {
    image.value = null;

    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      closeModal();
      return;
    }

    image.value = File(pickedFile.path);
    closeModal();
  }

  pickFromCamera() async {
    image.value = null;

    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      closeModal();
      return;
    }

    image.value = File(pickedFile.path);
    closeModal();
  }

  return SizedBox(
    width: WIDTH,
    height: WIDTH * 0.3,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: pickFromGallery,
              child: const Text("Pick Image from Device")),
          ElevatedButton(
              onPressed: pickFromCamera,
              child: const Text("Pick Image from Camera")),
        ],
      ),
    ),
  );
}
