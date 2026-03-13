import 'package:flutter/material.dart';

class ConditionsPage extends StatelessWidget {
  final String filiereNom;

  const ConditionsPage({
    super.key,
    required this.filiereNom,
  });

  @override
  Widget build(BuildContext context) {
    // Les textes ici correspondent exactement aux données de FilierePage
    final Map<String, String> conditions = {
      "INFORMATIQUE":
      "• Bac scientifique requis (C, D, E, H)\n"
          "• Bonne base en mathématiques\n"
          "• Maîtrise de l’outil informatique\n"
          "• Durée : 03 ans (Licence)\n"
          "• Orientation Campus Faso obligatoire",

      "DROIT":
      "• Bac littéraire ou scientifique (A, D, G)\n"
          "• Bonne capacité d’analyse et de synthèse\n"
          "• Excellente expression écrite\n"
          "• Durée : 03 ans (Licence)\n"
          "• Orientation Campus Faso obligatoire",

      "PHYSIQUE":
      "• Bac scientifique obligatoire (C, D, E)\n"
          "• Excellente moyenne en sciences physiques\n"
          "• Réussite au concours ou sélection\n"
          "• Durée : 03 ans (Licence)\n"
          "• Orientation Campus Faso obligatoire",

      "ÉCONOMIE":
      "• Bac scientifique ou technique (C, D, G)\n"
          "• Intérêt pour la gestion et les chiffres\n"
          "• Bonne logique mathématique\n"
          "• Durée : 03 ans (Licence)\n"
          "• Orientation Campus Faso obligatoire",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Conditions - $filiereNom", style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF1A237E)),
                        const SizedBox(width: 10),
                        Text(
                          filiereNom,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    Text(
                      conditions[filiereNom] ?? "Détails bientôt disponibles pour cette filière.",
                      style: const TextStyle(fontSize: 16, height: 1.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}