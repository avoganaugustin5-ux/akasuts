import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Tes imports d'écrans
import 'package:akasuts/screens/accueil.dart'; // Vérifie bien le nom du fichier (home_page ou accueil)
import 'package:akasuts/login_page.dart';

void main() async {
  // 1. Initialisation des liaisons Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation de Firebase avec les options de plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. CONFIGURATION DE LA PERSISTENCE (Crucial pour l'UTS)
  // Cela permet à Firestore de stocker les données sur le téléphone
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AKASUTS',
      debugShowCheckedModeBanner: false,

      // Personnalisation du thème pour tout le projet
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1A237E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
          secondary: Colors.orange, // Ta couleur d'accent pour les boutons
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // GESTIONNAIRE D'AUTHENTIFICATION (AuthWrapper)
      // Grâce à la persistance de Firebase Auth, l'utilisateur reste
      // connecté même s'il ferme l'application ou perd internet.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Pendant que l'app vérifie l'état de connexion
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)),
              ),
            );
          }

          // Si l'utilisateur est déjà connecté (donnée présente en cache local)
          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage();
          }

          // Sinon, redirection vers la page de connexion
          return const LoginPage();
        },
      ),
    );
  }
}