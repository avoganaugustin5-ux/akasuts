import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:akasuts/screens/accueil.dart'; // Importation de ton vrai accueil

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Ce flux écoute en permanence si l'utilisateur se connecte ou se déconnecte
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 1. Si la connexion est en cours (chargement)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Si l'utilisateur est connecté (présence de données)
        if (snapshot.hasData) {
          // Ici, on retourne ta vraie HomePage définie dans accueil.dart
          return const HomePage();
        }

        // 3. Sinon, on affiche la page de connexion
        return const LoginPage();
      },
    );
  }
}