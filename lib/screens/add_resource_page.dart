import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../services/storage_service.dart';

class AddResourcePage extends StatefulWidget {
  const AddResourcePage({super.key});

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final StorageService _storage = StorageService();

  String _selectedType = 'Cours'; // Valeur par défaut
  PlatformFile? _pickedFile;
  bool _isUploading = false;

  // Fonction pour choisir le fichier PDF
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  // Fonction pour envoyer vers Cloudinary et Firestore
  Future<void> _saveResource() async {
    if (!_formKey.currentState!.validate() || _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir le titre et choisir un PDF")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      String? fileUrl;

      // --- CORRECTION POUR LE WEB ---
      if (kIsWeb) {
        // Sur Web, on envoie les bytes directement
        if (_pickedFile!.bytes != null) {
          fileUrl = await _storage.uploadMedia(
            _pickedFile!, // On passe l'objet PlatformFile entier
            folder: 'resources_pdf',
          );
        }
      } else {
        // Sur Mobile, on utilise le chemin (ton code actuel)
        File fileToUpload = File(_pickedFile!.path!);
        fileUrl = await _storage.uploadMedia(fileToUpload);
      }

      if (!mounted) return;

      if (fileUrl != null) {
        await FirebaseFirestore.instance.collection('resources').add({
          'titre': _titleController.text.trim(),
          'type': _selectedType,
          'url': fileUrl,
          'date': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document ajouté !"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un Document")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titre du document (ex: Réseaux L3)"),
                validator: (value) => value!.isEmpty ? "Entrez un titre" : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['Cours', 'TD', 'TP', 'Examen'].map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: "Type de ressource"),
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_pickedFile == null ? "Choisir le PDF" : "Fichier : ${_pickedFile!.name}"),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _isUploading ? null : _saveResource,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("PUBLIER SUR AKASUTS", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}