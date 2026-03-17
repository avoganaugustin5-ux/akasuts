import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_resource_page.dart'; // IMPORTANT : Ajoute cet import pour que le bouton fonctionne

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  // Fonction pour ouvrir le lien Cloudinary (PDF)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw "Impossible d'ouvrir le lien $url";
      }
    } catch (e) {
      debugPrint("Erreur ouverture PDF : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ressources & Documents", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // === LE BOUTON FLOTTANT POUR AJOUTER ===
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddResourcePage()),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        // On trie par date pour avoir les derniers documents en premier
        stream: FirebaseFirestore.instance
            .collection('resources')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement des documents"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E)));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("Aucun document disponible pour le moment.",
                  style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
                  title: Text(
                    data['titre'] ?? data['title'] ?? 'Document sans titre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Type : ${data['type'] ?? data['category'] ?? 'Général'}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded, color: Color(0xFF1A237E), size: 30),
                    onPressed: () => _launchURL(data['url']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}