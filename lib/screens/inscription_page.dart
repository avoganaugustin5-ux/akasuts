import 'package:flutter/material.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comment s'inscrire", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Procédure d'inscription à l'UTS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            const SizedBox(height: 20),
            _stepCard("1", "Créez votre compte sur la plateforme Campus Faso.\n Faites un dépôt de dossier pour orientations,\n Puis patienter que les résultats sortent !\n "),
            _stepCard("2", " Durant la Période de paiement qui sera communiqué par Campus Faso, \nPayez vos frais d'inscription via Orange Money ou Moov Money."),
            _stepCard("3", "Patienter le début des cours (communiqué de la direction de votre UFR) pour vous rendre dans vos salles respectives."),
            const SizedBox(height: 30),
            const Center(
              child: Icon(Icons.info_outline, size: 50, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCard(String number, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.orange, child: Text(number, style: const TextStyle(color: Colors.white))),
        title: Text(text),
      ),
    );
  }
}