import 'package:flutter/material.dart';
import 'package:akasuts/screens/conditions_page.dart';

class FilierePage extends StatelessWidget {
  const FilierePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filieres = [
      {"nom": "INFORMATIQUE", "duree": "05 ans", "icon": "computer"},
      {"nom": "DROIT", "duree": "03 ans", "icon": "gavel"},
      {"nom": "MÉDECINE", "duree": "07 ans", "icon": "medical_services"},
      {"nom": "ÉCONOMIE", "duree": "03 ans", "icon": "trending_up"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          "Nos Filières",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher une filière...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Grille des filières
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: filieres.length,
              itemBuilder: (context, index) {
                return _buildFiliereCard(
                  context,
                  filieres[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ VERSION RECOMMANDÉE
  Widget _buildFiliereCard(
      BuildContext context, Map<String, String> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(data['icon']!),
              size: 40,
              color: const Color(0xFF1A237E),
            ),
            const SizedBox(height: 10),
            Text(
              data['nom']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              "Durée: ${data['duree']}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConditionsPage(
                      filiereNom: data['nom']!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "VOIR LE PROGRAMME",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Icône dynamique selon la filière
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case "computer":
        return Icons.computer;
      case "gavel":
        return Icons.gavel;
      case "medical_services":
        return Icons.medical_services;
      case "trending_up":
        return Icons.trending_up;
      default:
        return Icons.school;
    }
  }
}
