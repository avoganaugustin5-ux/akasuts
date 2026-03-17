import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:akasuts/screens/filiere_page.dart';
import 'package:akasuts/screens/payment_page.dart';
import 'package:akasuts/screens/resources_page.dart';
import 'package:akasuts/services/storage_service.dart';
import 'package:akasuts/screens/inscription_page.dart';
import 'package:akasuts/screens/about_uts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final StorageService _storageService = StorageService();

  bool _isOffline = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = (result == ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // MISE À JOUR : Cette fonction utilise maintenant Cloudinary via ton StorageService
  Future<void> _updatePhoto() async {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion requise pour changer la photo")),
      );
      return;
    }

    final image = await _storageService.pickImage();
    if (image != null && user != null) {
      // On affiche un message de patience
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Téléchargement de la photo..."), duration: Duration(seconds: 2)),
      );

      String? url = await _storageService.uploadMedia(image); // Utilise ton nouveau service Cloudinary

      if (url != null) {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'photoUrl': url, // On garde le nom 'photoUrl' pour la cohérence de ton code
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Photo mise à jour !"), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(
          'assets/images/logo_uts.jpg',
          height: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          // AJOUT : Petit aperçu de la photo dans l'AppBar (comme sur Facebook/Gmail)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                String? url = snapshot.data!.get('photoUrl');
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
                    child: (url == null || url.isEmpty) ? const Icon(Icons.person, size: 20, color: Colors.white) : null,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
        bottom: _isOffline
            ? PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            color: Colors.orange,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text("Mode hors-ligne (Données locales)",
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HERO SECTION (Photo de Profil) =================
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A237E),
                      image: DecorationImage(
                        image: AssetImage('assets/images/campus.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                          return const CircularProgressIndicator(color: Colors.white);
                        }
                        var userData = snapshot.data;
                        String? photoUrl;
                        String displayName = "CHARGEMENT...";

                        if (userData != null && userData.exists) {
                          photoUrl = userData.get('photoUrl');
                          displayName = "${userData.get('prenom')} ${userData.get('nom')}".toUpperCase();
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: _updatePhoto,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                                        ? NetworkImage(photoUrl)
                                        : null,
                                    child: (photoUrl == null || photoUrl.isEmpty)
                                        ? const Icon(Icons.person, size: 60, color: Color(0xFF1A237E))
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              displayName,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userData != null ? userData.get('role').toString().toUpperCase() : "",
                              style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }
                  ),
                ],
              ),

              // ... (le reste de ton code pour les boutons et actualités reste inchangé)
              _buildActionButtons(context),
              _buildNewsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // MISE À JOUR DU DRAWER : Utilise StreamBuilder pour la photo en temps réel
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          String name = "Chargement...";
          String email = user?.email ?? "";
          String? photoUrl;

          if (snapshot.hasData && snapshot.data!.exists) {
            name = "${snapshot.data!.get('prenom')} ${snapshot.data!.get('nom')}";
            photoUrl = snapshot.data!.get('photoUrl');
          }

          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1A237E)),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
                  child: (photoUrl == null || photoUrl.isEmpty) ? const Icon(Icons.person, color: Color(0xFF1A237E), size: 40) : null,
                ),
                accountName: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(email),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Accueil"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text("Nos Filières"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FilierePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_books, color: Colors.blue),
                title: const Text("Ressources PDF"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourcesPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.orange),
                title: const Text("À propos de l'UTS"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUtsPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.green),
                title: const Text("Paiement Scolarité"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(userEmail: email, userName: name)));
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text("Déconnexion"),
                onTap: () => FirebaseAuth.instance.signOut(),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
              )
            ],
          );
        },
      ),
    );
  }

  // Méthodes d'aide pour garder le code propre
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          _buildActionButton(context, "DÉCOUVRIR NOS FILIÈRES"),
          const SizedBox(width: 10),
          _buildActionButton(context, "COMMENT S'INSCRIRE"),
        ],
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Actualités", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: const Row(
            children: [
              Expanded(child: Text("Joignable sur les réseaux sociaux...", style: TextStyle(color: Colors.white, fontSize: 13))),
              FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 22),
              SizedBox(width: 15),
              FaIcon(FontAwesomeIcons.youtube, color: Colors.red, size: 22),
              SizedBox(width: 15),
              FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0077B5), size: 22),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _buildNewsCard("Actualités", "Nouveautés sur le campus Thomas Sankara pour l'année 2026.", "assets/images/evenement.jpg"),
              _buildNewsCard("Événements", "Conférence annuelle sur le développement durable.", "assets/images/etudiant.jpg"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == "DÉCOUVRIR NOS FILIÈRES") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FilierePage()));
          } else if (label == "COMMENT S'INSCRIRE") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InscriptionPage()));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1D2951),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 4))],
          ),
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildNewsCard(String title, String content, String imagePath) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 5),
                Text(content, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}