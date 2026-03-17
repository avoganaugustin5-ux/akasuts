import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class StorageService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
      'drjtn4fj3',
      'akasuts_preset',
      cache: false
  );

  final ImagePicker _picker = ImagePicker();

  // Pour choisir une image
  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  // Fonction d'upload universelle (Web et Mobile)
  Future<String?> uploadMedia(dynamic fileSource, {String folder = 'akasuts_uploads'}) async {
    try {
      CloudinaryResponse response;

      if (kIsWeb) {
        Uint8List bytes;
        String fileName;

        if (fileSource is XFile) {
          bytes = await fileSource.readAsBytes();
          fileName = fileSource.name;
        } else if (fileSource is PlatformFile) {
          bytes = fileSource.bytes!;
          fileName = fileSource.name;
        } else if (fileSource is File) {
          bytes = await fileSource.readAsBytes();
          fileName = fileSource.path.split('/').last;
        } else {
          throw "Format non supporté sur Web";
        }

        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: fileName,
            folder: folder,
          ),
        );
      }
      else {
        String filePath;
        if (fileSource is XFile) {
          filePath = fileSource.path;
        } else if (fileSource is File) {
          filePath = fileSource.path;
        } else {
          throw "Format non supporté sur Mobile";
        }

        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            filePath,
            folder: folder,
          ),
        );
      }

      return response.secureUrl;
    } catch (e) {
      debugPrint("Erreur upload Cloudinary : $e");
      return null;
    }
  }
}