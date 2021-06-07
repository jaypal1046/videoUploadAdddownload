import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePick {
  static Future<File> pickImage( ImageSource source) async {
    PickedFile selectImage =
    await ImagePicker.platform.pickImage(source: source);
    File selectfile = File(selectImage.path);
    return selectfile;
  }

  static Future<File> pickVideo(ImageSource source) async {
    PickedFile selectVideo =
    await ImagePicker.platform.pickVideo(source: source);
    File selectfile = File(selectVideo.path);
    return selectfile;
  }
}
