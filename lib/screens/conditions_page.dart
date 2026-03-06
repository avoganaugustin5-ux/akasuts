import 'package:flutter/material.dart';

class ConditionsPage extends StatelessWidget {
  final String filiereNom;

  const ConditionsPage({
    super.key,
    required this.filiereNom,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> conditions = {
      "INFORMATIQUE":
      "• Bac scientifique requis\n"
          "• Bonne base en mathématiques\n"
          "• Maîtrise de l’outil informatique\n"
          "• Durée : 3 ans"
          "• Orientation Campus Faso Obligatoire (Choix MPCI)",

      "DROIT":
      "• Bac littéraire ou scientifique\n"
          "• Bonne capacité d’analyse\n"
          "• Excellente expression écrite\n"
          "• Durée : 3 ans"
          "• Orientation Campus Faso Obligatoire (Choix SJP)",

      "LIME LISE":
      "• Bac scientifique obligatoire\n"
          "• Excellente moyenne en sciences\n"
          "• Réussite au concours d’entrée\n"
          "• Durée : 3 ans\n",


      "ÉCONOMIE":
      "• Bac toutes séries accepté\n"
          "• Intérêt pour la gestion et les chiffres\n"
          "• Bonne logique mathématique\n"
          "• Durée : 5 ans\n"
          "• Orientation Campus Faso Obligatoire (Choix SEG)",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Conditions - $filiereNom"),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              conditions[filiereNom] ??
                  "Conditions non disponibles.",
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
