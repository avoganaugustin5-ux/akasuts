import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // ✅ Import indispensable pour kIsWeb
import 'firebase_options.dart';
import 'auth_wrapper.dart';

void main() async {
  // 1. Indispensable pour démarrer les services natifs
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation Firebase selon la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Configuration Firestore optimisée
  if (!kIsWeb) {
    // Configuration spécifique au Mobile (Android/iOS)
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } else {
    // Sur le Web, la persistance est gérée différemment par le navigateur
    // On peut forcer l'indexdb si nécessaire, mais le réglage par défaut est stable.
    await FirebaseFirestore.instance.enablePersistence();
  }

  runApp(const UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AKASUTS - Université Thomas Sankara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}