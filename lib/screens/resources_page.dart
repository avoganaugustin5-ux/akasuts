import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir les PDF
import 'package:akasuts/screens/add_resource_page.dart'; // Import crucial pour le bouton +

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  // Fonction pour ouvrir le lien du PDF
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le document")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ressources & Documents"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('resources')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Aucun document disponible pour le moment."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              String titre = doc['titre'] ?? 'Document sans titre';
              String type = doc['type'] ?? 'Général';
              String url = doc['url'] ?? '';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
                  title: Text(
                    titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Catégorie : $type"),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: Color(0xFF1A237E)),
                    onPressed: () => _launchURL(url),
                  ),
                  onTap: () => _launchURL(url), // Ouvre aussi le PDF au clic sur la ligne
                ),
              );
            },
          );
        },
      ),

      // --- LE BOUTON + QUI AVAIT DISPARU ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        tooltip: "Ajouter un document",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddResourcePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}