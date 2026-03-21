import 'dart:async'; // Nécessaire pour le Timer du carrousel
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- VARIABLES POUR LE CARROUSEL ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  // Tes 2 nouvelles images avec leurs citations
  final List<Map<String, String>> _inspirationalData = [
    {
      "image": "assets/images/etudiante.jpg",
      "quote": "L'éducation est l'arme la plus puissante pour changer le monde.",
      "author": "- Nelson Mandela"
    },
    {
      "image": "assets/images/etudiants.jpg",
      "quote": "On ne subit pas l'avenir, on le fait.",
      "author": "- Joseph Ki-ZERBO"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Démarrer le carrousel automatique dès l'ouverture de la page
    _startCarousel();
  }

  @override
  void dispose() {
    // NETTOYAGE OBLIGATOIRE des contrôleurs pour éviter les fuites de mémoire
    _carouselTimer?.cancel();
    _pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- LOGIQUE DU CARROUSEL AUTOMATIQUE ---
  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _inspirationalData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // --- LOGIQUE DE RÉINITIALISATION DU MOT DE PASSE ---
  Future<void> _resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email requis pour la récupération."), backgroundColor: Colors.orange),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Vérifiez vos emails"),
          content: Text("Un lien de récupération a été envoyé à $email."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red));
    }
  }

  // --- LOGIQUE DE CONNEXION ---
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez remplir tous les champs.")));
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Connexion AKASUTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
      ),
      // --- SINGLECHILDSCROLLVIEW ICI ---
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- CARROUSEL ANIMÉ (Prend 45% de la hauteur de l'écran) ---
            _buildAnimatedCarousel(),

            // --- FORMULAIRE DE CONNEXION (Padding standard) ---
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email institutionnel",
                      prefixIcon: const Icon(Icons.email, color: Color(0xFF1A237E)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF1A237E)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: const Text("Mot de passe oublié ?", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("SE CONNECTER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: const Text("Nouveau à l'UTS ? Créez un compte ici", style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CARROUSEL ---
  Widget _buildAnimatedCarousel() {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.45, // Prend 45% de la hauteur de l'écran
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Le gestionnaire de pages (le carrousel)
          PageView.builder(
            controller: _pageController,
            itemCount: _inspirationalData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // L'Image (en arrière-plan)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      _inspirationalData[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Le Gradient (pour la lisibilité du texte)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1A237E).withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Le Texte (Citation + Auteur)
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\"${_inspirationalData[index]["quote"]!}\"",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _inspirationalData[index]["author"]!,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Les indicateurs de page (les petits points)
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: List.generate(_inspirationalData.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.orange : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}