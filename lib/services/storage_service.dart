import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart'; // IMPORTANT : Ajoute cet import


class StorageService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
      'drjtn4fj3',
      'akasuts_preset',
      cache: false
  );

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  // Fonction universelle mise à jour
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
          // C'EST CETTE PARTIE QUI RÉSOUT TON ERREUR SUR CHROME
          bytes = fileSource.bytes!;
          fileName = fileSource.name;
        } else if (fileSource is File) {
          bytes = await fileSource.readAsBytes();
          fileName = fileSource.path.split('/').last;
        } else {
          throw "Format non supporté sur Web : ${fileSource.runtimeType}";
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
        } else if (fileSource is PlatformFile) {
          filePath = fileSource.path!;
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