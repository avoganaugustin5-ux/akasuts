import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
//import 'package:url_launcher/url_launcher.dart';

// Tes imports cruciaux préservés
import 'package:akasuts/screens/add_resource_page.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Map<String, bool> _isDownloading = {};
  final Map<String, double> _downloadProgress = {}; // Pour le pourcentage %

  // --- LOGIQUE HORS-LIGNE (SYSTÈME DE CACHE) ---

  Future<String> _getLocalPath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName.pdf";
  }

  // Vérifie si le fichier existe déjà sur le téléphone
  Future<bool> _existsLocally(String id) async {
    final path = await _getLocalPath(id);
    return File(path).exists();
  }

  Future<void> _downloadAndOpen(String url, String title, String id) async {
    final path = await _getLocalPath(id);
    final file = File(path);

    if (await file.exists()) {
      _openPDF(path, title);
    } else {
      setState(() {
        _isDownloading[id] = true;
        _downloadProgress[id] = 0.0;
      });

      try {
        await Dio().download(
          url,
          path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _downloadProgress[id] = received / total;
              });
            }
          },
        );
        _openPDF(path, title);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur : Vérifiez la config Cloudinary (PDF autorisés)")),
        );
      } finally {
        setState(() {
          _isDownloading[id] = false;
        });
      }
    }
  }

  void _openPDF(String path, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title, style: const TextStyle(fontSize: 16)),
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          body: PDFView(filePath: path),
        ),
      ),
    );
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
            return const Center(child: Text("Aucun document disponible."));
          }

          // Regroupement dynamique par filière (Type)
          final docs = snapshot.data!.docs;
          final Map<String, List<QueryDocumentSnapshot>> groups = {};
          for (var doc in docs) {
            String type = doc['type'] ?? 'Général';
            if (!groups.containsKey(type)) groups[type] = [];
            groups[type]!.add(doc);
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: groups.entries.map((entry) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  leading: const Icon(Icons.folder_special, color: Colors.orange),
                  title: Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))
                  ),
                  children: entry.value.map((doc) => _buildDocTile(doc)).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A237E),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddResourcePage()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDocTile(QueryDocumentSnapshot doc) {
    String titre = doc['titre'] ?? 'Document';
    String url = doc['url'] ?? '';
    String id = doc.id;

    return FutureBuilder<bool>(
      future: _existsLocally(id),
      builder: (context, snapshot) {
        bool isCached = snapshot.data ?? false;
        double progress = _downloadProgress[id] ?? 0.0;
        int pct = (progress * 100).toInt();

        return ListTile(
          leading: Icon(
              Icons.picture_as_pdf,
              color: isCached ? Colors.green : Colors.redAccent
          ),
          title: Text(titre, style: const TextStyle(fontSize: 14)),
          subtitle: isCached
              ? const Text("Disponible hors-ligne", style: TextStyle(color: Colors.green, fontSize: 12))
              : const Text("Cliquer pour télécharger", style: TextStyle(fontSize: 11)),
          trailing: _isDownloading[id] == true
              ? Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: progress, strokeWidth: 3, color: Colors.orange),
              Text("$pct%", style: const TextStyle(fontSize: 10)),
            ],
          )
              : Icon(
            isCached ? Icons.check_circle : Icons.download_for_offline,
            color: isCached ? Colors.green : const Color(0xFF1A237E),
          ),
          onTap: () => _downloadAndOpen(url, titre, id),
        );
      },
    );
  }
}