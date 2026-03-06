import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? photoUrl; // Le "?" signifie que la photo peut être vide au début

  UserModel({
    required this.uid,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  // Convertit un document Firebase en objet Dart (très utile !)
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      nom: doc['nom'] ?? '',
      prenom: doc['prenom'] ?? '',
      email: doc['email'] ?? '',
      role: doc['role'] ?? 'etudiant',
      photoUrl: doc['photoUrl'],
    );
  }

  // Convertit notre objet en Map pour l'envoyer à Firebase
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
    };
  }
}