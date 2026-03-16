import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  // Vos identifiants réels récupérés sur Cloudinary
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
      'drjtn4fj3',         // Ton Cloud Name
      'akasuts_preset',    // Ton Upload Preset
      cache: false
  );

  final ImagePicker _picker = ImagePicker();

// ... le reste du code reste identique ...
}

  final ImagePicker _picker = ImagePicker();

  // 1. Choisir l'image (Inchangé, c'est parfait)
  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  // 2. Envoyer l'image vers Cloudinary
  Future<String?> uploadMedia(XFile image, {String folder = 'akasuts_uploads'}) async {
    try {
      CloudinaryResponse response;

      if (kIsWeb) {
        // Pour le Web : on utilise les bytes
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            await image.readAsBytes(),
            identifier: image.name,
            folder: folder,
          ),
        );
      } else {
        // Pour le Mobile : on utilise le chemin du fichier
        response = await _cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            image.path,
            folder: folder,
          ),
        );
      }

      // On retourne l'URL sécurisée générée par Cloudinary
      return response.secureUrl;
    } catch (e) {
      debugPrint("Erreur upload Cloudinary : $e");
      return null;
    }
  }
}