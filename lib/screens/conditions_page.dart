import 'package:flutter/material.dart';

class ConditionsPage extends StatelessWidget {
  final String filiereNom;

  const ConditionsPage({
    super.key,
    required this.filiereNom,
  });

  @override
  Widget build(BuildContext context) {
    // Données enrichies pour toutes les filières
    final Map<String, Map<String, String>> detailsFilieres = {
      "INFORMATIQUE": {
        "conditions": "• Bac scientifique requis (C, D, E, H)\n• Bonne base en mathématiques\n• Orientation Campus Faso obligatoire",
        "specialites": "• L1 : Tronc commun\n• L2/L3 : Génie Logiciel ou Réseaux & Télécoms",
        "debouches": "• Développeur Web/Mobile\n• Administrateur Réseaux\n• Analyste de données"
      },
      "DROIT": {
        "conditions": "• Bac A, D ou G\n• Capacité d'analyse et de synthèse\n• Bonne maîtrise du français",
        "specialites": "• L1/L2 : Tronc commun (Droit général)\n• L3 : Droit Public (Administration, État) ou Droit Privé (Affaires, Justice)",
        "debouches": "• Avocat / Magistrat\n• Juriste d'entreprise\n• Concours administratifs"
      },
      "ÉCONOMIE": {
        "conditions": "• Bac C, D ou G\n• Excellente logique mathématique\n• Intérêt pour l'actualité financière",
        "specialites": "• L1/L2 : SEG (Sciences Éco & Gestion)\n• L3 : Économie Agricole, Économie Publique ou Analyse Macroéconomique",
        "debouches": "• Économiste\n• Gestionnaire de projets\n• Analyste financier"
      },
      "MATHÉMATIQUES": {
        "conditions": "• Bac C ou E (D sous conditions)\n• Esprit logique et abstrait\n• Moyenne élevée en calcul",
        "specialites": "• LIME : Ingénierie Mathématique\n• LISE : Statistique et Économétrie",
        "debouches": "• Data Scientist\n• Enseignant-Chercheur\n• Statisticien"
      },
      "PHYSIQUE": {
        "conditions": "• Bac scientifique (C, D, E)\n• Excellente base en sciences physiques",
        "specialites": "• L3 : Énergie Solaire ou Mécanique Appliquée",
        "debouches": "• Ingénieur Énergie\n• Technicien spécialisé\n• Recherche"
      },
      "CHIMIE / APC": {
        "conditions": "• Bac scientifique (C, D)\n• Aptitude pour les travaux de laboratoire",
        "specialites": "• Analyse Physico-Chimique (APC)\n• Contrôle Qualité",
        "debouches": "• Responsable Labo\n• Industrie pharmaceutique\n• Environnement"
      },
    };

    final data = detailsFilieres[filiereNom] ?? {
      "conditions": "Détails bientôt disponibles.",
      "specialites": "Information à venir.",
      "debouches": "Information à venir."
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text("Détails : $filiereNom", style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard("Conditions d'admission", data["conditions"]!, Icons.assignment_turned_in, Colors.blue),
            const SizedBox(height: 15),
            _buildInfoCard("Spécialisations (Parcours)", data["specialites"]!, Icons.account_tree_rounded, Colors.orange),
            const SizedBox(height: 15),
            _buildInfoCard("Débouchés professionnels", data["debouches"]!, Icons.work_history, Colors.green),

            const SizedBox(height: 30),

            // Petit bouton d'action contextuel
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("RETOUR AUX FILIÈRES"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color accentColor) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor),
                const SizedBox(width: 12),
                Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: accentColor)),
              ],
            ),
            const Divider(height: 25),
            Text(
              content,
              style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}