import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'firebase_options.dart';
import 'auth_wrapper.dart';

void main() async {
  // 1. Indispensable pour démarrer les services natifs (Firebase, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation de Firebase avec les options générées
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Configuration de la persistance Firestore (Mode Hors-ligne)
  // On utilise la syntaxe moderne 'Settings' qui remplace les anciennes fonctions
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AKASUTS - Université Thomas Sankara',
      debugShowCheckedModeBanner: false, // Enlève le bandeau "Debug" pour ton rapport

      // Configuration visuelle (Couleurs officielles UTS)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Bleu Nuit
          primary: const Color(0xFF1A237E),
          secondary: Colors.orange, // Couleur d'accent pour les boutons/icônes
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7), // Gris très clair moderne

        // Personnalisation globale des AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // Démarre sur l'AuthWrapper pour vérifier si l'étudiant est connecté
      home: const AuthWrapper(),
    );
  }
}