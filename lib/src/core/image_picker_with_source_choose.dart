import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWithSourceChoose {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(BuildContext context) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context1) => CupertinoAlertDialog(
        
        title: Text("Bildquelle auswählen"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context1, ImageSource.camera),
            child: Text(
              "Kamera",
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context1, ImageSource.gallery),
            child: Text(
              "Mediathek",
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context1);
            },
            child: Text(
              "Abbrechen",
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        debugPrint("-------------");
        debugPrint("Bild ausgewählt: ${pickedFile.path}");
        debugPrint("-------------");
        return File(pickedFile.path);
      }
    }
    debugPrint("-------------");
    debugPrint("Kein Bild ausgewählt.");
    debugPrint("-------------");
    return null;
  }
}



  // MATERIAL DESIGN

  //   final ImageSource? source = await showDialog<ImageSource>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Bild auswählen"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, ImageSource.camera),
  //           child: Text("Kamera"),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, ImageSource.gallery),
  //           child: Text("Mediathek"),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, null),
  //           child: Text("Abbrechen"),
  //         ),
  //       ],
  //     ),
  //   );