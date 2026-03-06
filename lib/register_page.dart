import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    try {
      // 1. Créer le compte utilisateur
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Enregistrer dans Firestore
      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
        "nom": nomController.text.trim(),
        "prenom": prenomController.text.trim(),
        "email": emailController.text.trim(),
        "role": "etudiant",
        "photoUrl": null, // Initialisé à null pour la future photo
        "created_at": Timestamp.now(),
      });

      // 3. Sécurité : Vérifier si l'écran est toujours là avant de faire Navigator.pop
      if (!mounted) return;
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription Étudiant")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nomController, decoration: const InputDecoration(labelText: "Nom")),
              TextField(controller: prenomController, decoration: const InputDecoration(labelText: "Prénom")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Mot de passe"), obscureText: true),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    if (nomController.text.isNotEmpty &&
                        prenomController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      register();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Veuillez remplir tous les champs")),
                      );
                    }
                  },
                  child: const Text("Créer mon compte")
              ),
            ],
          ),
        ),
      ),
    );
  }
}