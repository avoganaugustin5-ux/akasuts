import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InscriptionPage extends StatefulWidget {
  // Correction : Ajout du paramètre key
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sinscrire() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulation ou logique d'inscription
        await FirebaseFirestore.instance.collection('inscriptions_temp').add({
          'nom': _nomController.text.trim(),
          'prenom': _prenomController.text.trim(),
          'date': FieldValue.serverTimestamp(),
        });

        // Correction : Vérification mounted avant d'utiliser le context
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inscription réussie !"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"), // Correction : Ajout de const
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Correction : Ajout de const
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: "Nom"), // Correction : const
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 10), // Correction : const
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: "Prénom"), // Correction : const
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 20), // Correction : const
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _sinscrire,
                child: const Text("S'inscrire"), // Correction : const
              ),
            ],
          ),
        ),
      ),
    );
  }
}