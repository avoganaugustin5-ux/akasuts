import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // 1. Choisir l'image
  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  // 2. Envoyer l'image vers Firebase Storage
  Future<String?> uploadProfilePhoto(XFile image, String uid) async {
    try {
      Reference ref = _storage.ref().child('profile_photos').child('$uid.jpg');

      if (kIsWeb) {
        // Spécifique au Web
        await ref.putData(await image.readAsBytes());
      } else {
        // Spécifique au Mobile
        await ref.putFile(File(image.path));
      }

      // On récupère le lien URL de la photo stockée
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Erreur upload : $e");
      return null;
    }
  }
}