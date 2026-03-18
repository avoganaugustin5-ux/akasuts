import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // IMPORTATION CRUCIALE

// Tes imports de pages
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
      setState(() => _isOffline = (result == ConnectivityResult.none));
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // FONCTION DE TÉLÉCHARGEMENT DE L'APK
  Future<void> _launchDownloadURL() async {
    final Uri url = Uri.parse('https://github.com/avoganaugustin5-ux/akasuts/releases/download/v1.0.0/akasuts-v1.0.apk');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Force l'ouverture dans le navigateur pour le téléchargement
        );
      } else {
        throw 'Impossible d\'ouvrir le lien de téléchargement';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  // FONCTION MISE À JOUR PHOTO
  Future<void> _updatePhoto() async {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion requise pour changer la photo")),
      );
      return;
    }

    final image = await _storageService.pickImage();
    if (image != null && user != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Téléchargement de la photo..."), duration: Duration(seconds: 2)),
      );

      String? url = await _storageService.uploadMedia(image);

      if (!mounted) return;

      if (url != null) {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'photoUrl': url,
        });

        if (!mounted) return;
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
        title: Image.asset('assets/images/logo_uts.jpg', height: 40, fit: BoxFit.contain),
        actions: [
          _buildTopAvatar(),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
        bottom: _isOffline ? _buildOfflineBanner() : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SECTION HERO
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/campus.jpg'), fit: BoxFit.cover),
                    ),
                  ),
                  Container(height: 250, color: Colors.black.withOpacity(0.6)),
                  _buildHeroProfileContent(),
                ],
              ),

              _buildActionButtons(context),

              // SECTION RÉSEAUX SOCIAUX
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  children: [
                    Expanded(child: Text("Joignable sur les réseaux sociaux...", style: TextStyle(color: Colors.white, fontSize: 12))),
                    FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 20),
                    SizedBox(width: 15),
                    FaIcon(FontAwesomeIcons.facebook, color: Colors.blue, size: 20),
                    SizedBox(width: 15),
                    FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0077B5), size: 20),
                  ],
                ),
              ),

              // NOUVEAU : BOUTON DE TÉLÉCHARGEMENT APK
              _buildDownloadButton(),

              // SECTION ACTUALITÉS
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(alignment: Alignment.centerLeft, child: Text("Actualités du campus", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ),
              _buildNewsCard("Événements", "Conférence annuelle Thomas Sankara.", 'assets/images/evenement.jpg'),
              _buildNewsCard("Vie Étudiante", "Nouveautés sur le campus.", 'assets/images/etudiant.jpg'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE COMPOSANTS ---

  Widget _buildDownloadButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _launchDownloadURL,
        icon: const Icon(Icons.file_download, color: Colors.white),
        label: const Text(
          "TÉLÉCHARGER LA DERNIÈRE VERSION (APK)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildTopAvatar() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        String? url;
        if (snapshot.hasData && snapshot.data!.exists) url = snapshot.data!.get('photoUrl');
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(radius: 15, backgroundImage: (url != null && url.isNotEmpty) ? NetworkImage(url) : null, child: (url == null) ? const Icon(Icons.person, size: 15) : null),
        );
      },
    );
  }

  PreferredSize _buildOfflineBanner() {
    return PreferredSize(preferredSize: const Size.fromHeight(30), child: Container(color: Colors.orange, height: 30, alignment: Alignment.center, child: const Text("Mode hors-ligne", style: TextStyle(color: Colors.white, fontSize: 11))));
  }

  Widget _buildHeroProfileContent() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        String? photoUrl;
        String name = "UTIEN";
        if (snapshot.hasData && snapshot.data!.exists) {
          photoUrl = snapshot.data!.get('photoUrl');
          name = "${snapshot.data!.get('prenom')} ${snapshot.data!.get('nom')}".toUpperCase();
        }
        return Column(
          children: [
            GestureDetector(
              onTap: _updatePhoto,
              child: Stack(
                children: [
                  CircleAvatar(radius: 55, backgroundColor: Colors.white, backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null, child: (photoUrl == null) ? const Icon(Icons.person, size: 60) : null),
                  Positioned(bottom: 0, right: 5, child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, size: 20, color: Colors.white))),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildMainBtn(context, "DÉCOUVRIR NOS FILIÈRES", const FilierePage()),
          const SizedBox(width: 10),
          _buildMainBtn(context, "COMMENT S'INSCRIRE", const InscriptionPage()),
        ],
      ),
    );
  }

  Widget _buildMainBtn(BuildContext context, String label, Widget page) {
    return Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D2951), padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)), child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))));
  }

  Widget _buildNewsCard(String title, String desc, String imgPath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(imgPath, width: 60, height: 60, fit: BoxFit.cover)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          String name = "Chargement...";
          String? photoUrl;
          if (snapshot.hasData && snapshot.data!.exists) {
            name = "${snapshot.data!.get('prenom')} ${snapshot.data!.get('nom')}";
            photoUrl = snapshot.data!.get('photoUrl');
          }
          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1A237E)),
                currentAccountPicture: CircleAvatar(backgroundImage: (photoUrl != null) ? NetworkImage(photoUrl) : null, child: (photoUrl == null) ? const Icon(Icons.person, size: 40) : null),
                accountName: Text(name),
                accountEmail: Text(user?.email ?? ""),
              ),
              ListTile(leading: const Icon(Icons.home), title: const Text("Accueil"), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.school, color: Colors.orange), title: const Text("Nos Filières"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FilierePage()))),
              ListTile(leading: const Icon(Icons.library_books, color: Colors.blue), title: const Text("Ressources PDF"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourcesPage()))),
              ListTile(leading: const Icon(Icons.payment, color: Colors.green), title: const Text("Paiement"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(userEmail: user?.email ?? "", userName: name)))),
              ListTile(leading: const Icon(Icons.info, color: Colors.blue), title: const Text("À propos"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUtsPage()))),
              const Spacer(),
              const Divider(),
              ListTile(leading: const Icon(Icons.exit_to_app, color: Colors.red), title: const Text("Déconnexion"), onTap: () => FirebaseAuth.instance.signOut()),
            ],
          );
        },
      ),
    );
  }
}