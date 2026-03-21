import 'package:flutter/material.dart';

class ConditionsPage extends StatelessWidget {
  final String filiereNom;

  const ConditionsPage({
    super.key,
    required this.filiereNom,
  });

  @override
  Widget build(BuildContext context) {
    // Données enrichies et vérifiées pour l'UTS
    final Map<String, Map<String, String>> detailsFilieres = {
      "INFORMATIQUE": {
        "conditions": "• Bac scientifique requis (C, D, E, H)\n• Bonne base en algorithmique et logique\n• Inscription via Campus Faso obligatoire",
        "specialites": "• L1/L2 : Tronc commun en Sciences et Technologies\n• L3 : Génie Logiciel (GL) ou Réseaux et Systèmes (RS)",
        "debouches": "• Développeur Full-Stack\n• Administrateur Systèmes & Réseaux\n• Expert en Cybersécurité / Data Analyst"
      },
      "DROIT": {
        "conditions": "• Bac A, D ou G\n• Excellente maîtrise de l'expression écrite et orale\n• Esprit d'analyse juridique et de synthèse",
        "specialites": "• L1/L2 : Droit général (Fondements juridiques)\n• L3 : Droit Public (Administration) ou Droit Privé (Affaires/Carrières Judiciaires)",
        "debouches": "• Avocat, Magistrat, Notaire\n• Conseiller juridique en entreprise\n• Cadre de l'administration publique"
      },
      "ÉCONOMIE": {
        "conditions": "• Bac C, D ou G\n• Forte aptitude pour les mathématiques appliquées\n• Esprit critique sur les enjeux socio-économiques",
        "specialites": "• L1/L2 : Sciences Économiques et de Gestion (SEG)\n• L3 : Économie Agricole, Publique ou Planification",
        "debouches": "• Analyste de projets de développement\n• Consultant en stratégie économique\n• Cadre dans les institutions financières (Banques/Assurances)"
      },
      "MATHÉMATIQUES": {
        "conditions": "• Bac C ou E (Bac D avec mention Très Bien en Maths)\n• Passion pour l'abstraction et la démonstration\n• Rigueur scientifique exemplaire",
        "specialites": "• L1/L2 : Mathématiques, Informatique, Physique et Chimie (MIPC)\n• L3 : Mathématiques Pures ou Mathématiques Appliquées",
        "debouches": "• Data Scientist / Ingénieur Statisticien\n• Expert en Modélisation Financière\n• Enseignant-Chercheur ou Cryptologue"
      },
      "PHYSIQUE": {
        "conditions": "• Bac scientifique (C, D, E)\n• Excellente maîtrise des lois physiques et du calcul\n• Curiosité pour les innovations technologiques",
        "specialites": "• L3 : Énergies Renouvelables (Solaire) ou Électronique Appliquée",
        "debouches": "• Ingénieur en efficacité énergétique\n• Spécialiste en maintenance industrielle\n• Chercheur en sciences des matériaux"
      },
      "CHIMIE / APC": {
        "conditions": "• Bac scientifique (C, D)\n• Goût prononcé pour l'expérimentation et le laboratoire\n• Précision et respect des protocoles de sécurité",
        "specialites": "• Analyse Physico-Chimique (APC)\n• Contrôle Qualité et Environnement",
        "debouches": "• Responsable contrôle qualité (Industrie)\n• Expert en environnement et pollution\n• Chimiste dans le secteur agroalimentaire"
      },
    };

    final data = detailsFilieres[filiereNom] ?? {
      "conditions": "Les critères spécifiques sont en cours de mise à jour par le décanat.",
      "specialites": "Les parcours seront détaillés lors de la rentrée académique.",
      "debouches": "Nombreuses opportunités dans les secteurs publics et privés."
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
            "Détails : $filiereNom",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard("Conditions d'admission", data["conditions"]!, Icons.verified_user_rounded, Colors.blue.shade800),
            const SizedBox(height: 15),
            _buildInfoCard("Spécialisations (Parcours)", data["specialites"]!, Icons.account_tree_rounded, Colors.orange.shade800),
            const SizedBox(height: 15),
            _buildInfoCard("Débouchés professionnels", data["debouches"]!, Icons.business_center_rounded, Colors.green.shade800),

            const SizedBox(height: 30),

            // Bouton de retour avec un style "Outline" pour varier du bouton plein
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              label: const Text("RETOUR AUX FILIÈRES", style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A237E),
                  side: const BorderSide(color: Color(0xFF1A237E), width: 2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color accentColor) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(left: BorderSide(color: accentColor, width: 6)), // Bordure latérale pour le style
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: accentColor, size: 28),
                  const SizedBox(width: 12),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accentColor)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(thickness: 1),
              ),
              Text(
                content,
                style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87, letterSpacing: 0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}