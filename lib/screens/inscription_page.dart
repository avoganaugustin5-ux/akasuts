import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/storage_service.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final StorageService _storage = StorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uploadedImageUrl;
  bool _isUploading = false; // Pour le spinner de la photo
  bool _isRegistering = false; // Pour le bouton "S'inscrire"

  // 1. Sélection et Upload immédiat vers Cloudinary
  Future<void> _selectAndUploadPhoto() async {
    final image = await _storage.pickImage();
    if (image != null) {
      setState(() => _isUploading = true);
      String? url = await _storage.uploadMedia(image);
      setState(() {
        _uploadedImageUrl = url;
        _isUploading = false;
      });
    }
  }

  // 2. Création du compte et sauvegarde dans Firestore
  Future<void> _registerUser() async {
    // Supposons que tu as des contrôleurs pour l'email et le mot de passe
    // String email = _emailController.text;

    setState(() => _isRegistering = true);

    try {
      // Création de l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: "email@univ-ts.bf", // À remplacer par tes variables
        password: "mon_mot_de_passe",
      );

      String uid = userCredential.user!.uid;

      // Enregistrement des infos dans Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': "email@univ-ts.bf",
        'profilePic': _uploadedImageUrl ?? "", // On stocke l'URL Cloudinary ici
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'etudiant',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compte créé avec succès !"), backgroundColor: Colors.green),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription AkaSuts")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Widget de la photo de profil
            GestureDetector(
              onTap: _isUploading ? null : _selectAndUploadPhoto,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[100],
                    backgroundImage: _uploadedImageUrl != null
                        ? NetworkImage(_uploadedImageUrl!)
                        : null,
                    child: _uploadedImageUrl == null && !_isUploading
                        ? Icon(Icons.person, size: 60, color: Colors.blue)
                        : null,
                  ),
                  if (_isUploading)
                    CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Bouton final d'inscription
            ElevatedButton(
              onPressed: _isRegistering ? null : _registerUser,
              child: _isRegistering
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Créer mon compte"),
            ),
          ],
        ),
      ),
    );
  }
}