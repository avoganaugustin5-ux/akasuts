import 'package:flutter/material.dart';
import 'package:akasuts/screens/conditions_page.dart';

class FilierePage extends StatelessWidget {
  const FilierePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste mise à jour avec les spécialités intégrées pour combler le vide UI
    final List<Map<String, dynamic>> filieres = [
      {
        "nom": "INFORMATIQUE",
        "duree": "03 ans",
        "icon": Icons.computer,
        "desc": "Génie Logiciel • Réseaux"
      },
      {
        "nom": "DROIT",
        "duree": "03 ans",
        "icon": Icons.gavel,
        "desc": "Droit Public • Privé"
      },
      {
        "nom": "ÉCONOMIE",
        "duree": "03 ans",
        "icon": Icons.trending_up,
        "desc": "Agricole • Publique • Macro"
      },
      {
        "nom": "PHYSIQUE",
        "duree": "03 ans",
        "icon": Icons.science,
        "desc": "Énergie Solaire • Mécanique"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Nos Filières",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de recherche stylisée (Réduit l'espace vide du haut)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher une spécialité...",
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

          const SizedBox(height: 15),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85, // Optimisation de l'espace vertical
              ),
              itemCount: filieres.length,
              itemBuilder: (context, index) {
                final item = filieres[index];
                return _buildEnhancedCard(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCard(BuildContext context, Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Petit badge de durée
            Align(
              alignment: Alignment.topRight,
              child: Text(
                data['duree'],
                style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),

            Icon(data['icon'], size: 42, color: const Color(0xFF1A237E)),
            const SizedBox(height: 10),

            Text(
              data['nom'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E)),
            ),

            const SizedBox(height: 4),

            // Affichage des sous-filières pour combler le vide
            Text(
              data['desc'],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontStyle: FontStyle.italic),
            ),

            const Spacer(),

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
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text("DÉTAILS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}