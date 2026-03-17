import 'package:flutter/material.dart';
import 'package:akasuts/screens/conditions_page.dart';

class FilierePage extends StatelessWidget {
  const FilierePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste enrichie avec tes nouvelles filières et spécialisations
    final List<Map<String, dynamic>> filieres = [
      {
        "nom": "INFORMATIQUE",
        "duree": "03 ans",
        "icon": Icons.computer,
        "specialites": ["Génie Logiciel", "Réseaux & Télécoms"]
      },
      {
        "nom": "DROIT",
        "duree": "03 ans",
        "icon": Icons.gavel,
        "specialites": ["Droit Public", "Droit Privé"]
      },
      {
        "nom": "ÉCONOMIE",
        "duree": "03 ans",
        "icon": Icons.trending_up,
        "specialites": ["Économie Agricole", "Économie Publique", "Macroéconomie"]
      },
      {
        "nom": "MATHÉMATIQUES",
        "duree": "03 ans",
        "icon": Icons.functions,
        "specialites": ["LIME (Ingénierie)", "LISE (Statistiques)"]
      },
      {
        "nom": "PHYSIQUE",
        "duree": "03 ans",
        "icon": Icons.science,
        "specialites": ["Énergie Solaire", "Mécanique Appliquée"]
      },
      {
        "nom": "CHIMIE / APC",
        "duree": "03 ans",
        "icon": Icons.biotech,
        "specialites": ["Analyse Physico-Chimique"]
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Gris très clair pour le contraste
      appBar: AppBar(
        title: const Text(
          "Offre de Formation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section de recherche optimisée
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Trouver une filière ou spécialité...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1A237E)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Espace réduit ici pour le design UI
          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78, // Ratio équilibré pour éviter le vide
              ),
              itemCount: filieres.length,
              itemBuilder: (context, index) {
                return _buildFiliereCard(context, filieres[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiliereCard(BuildContext context, Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Badge du haut
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  data['duree'],
                  style: const TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Icon(data['icon'], size: 45, color: const Color(0xFF1A237E)),
            const SizedBox(height: 8),

            Text(
              data['nom'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A237E)),
            ),

            const SizedBox(height: 4),

            // Affichage discret des spécialités (UX)
            Text(
              (data['specialites'] as List).join(" • "),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontStyle: FontStyle.italic),
            ),

            const Spacer(),

            // Bouton d'action pro
            SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConditionsPage(filiereNom: data['nom']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text("DÉTAILS", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}