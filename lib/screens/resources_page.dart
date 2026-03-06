import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  // Fonction pour ouvrir le lien PDF dans le navigateur ou l'app dédiée
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Impossible d'ouvrir le lien $url";
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('resources').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Une erreur est survenue"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                    data['title'] ?? 'Document sans titre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Catégorie : ${data['category'] ?? 'Général'}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded, color: Color(0xFF1A237E)),
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