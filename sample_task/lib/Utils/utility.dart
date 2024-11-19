import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile?> pickImage({required ImageSource source}) async {
  // Request appropriate permission based on source
  Permission permission;
  if (source == ImageSource.camera) {
    permission = Permission.camera;
  } else {
    permission = Permission.photos;
  }

  print(permission);
  // Check permission status and request if necessary
  var status = await permission.status;
  print(status);
  if (status.isDenied) {
    print('yes denied');
    await openAppSettings();
    if (await permission.request().isGranted) {
      // Permission granted, proceed to pick image
    } else {
      // Permission denied, handle accordingly (e.g., show a dialog)
      return null;
    }
  } else if (status.isGranted) {
    // Permission already granted
  } else {
    // Permanently denied, Restricted, Limited
    // Open app settings for manual configuration by the user
    openAppSettings();
    return null;
  }

  final ImagePicker picker = ImagePicker();
  try {
    XFile? pickedFile = await picker.pickImage(source: source);
    return pickedFile;
  } catch (e) {
    // Handle error (e.g., user cancels image picking)
    print('Error picking image: $e');
    return null;
  }
}


// // For picking image from gallery
// XFile? imageFromGallery = await pickImage(ImageSource.gallery);
// if (imageFromGallery != null) {
//   // Process the image
// }


// // For taking a picture with the camera
// XFile? imageFromCamera = await pickImage(ImageSource.camera);
// if (imageFromCamera != null) {
//   // Process the image
// }

