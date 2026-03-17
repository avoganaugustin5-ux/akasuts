import 'package:flutter/material.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Procédure d'Inscription"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête visuel
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.05),
              ),
              child: const Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFF1A237E)),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Comment s'inscrire à l'UTS ?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Voici les étapes à suivre pour valider votre cursus académique cette année :",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),

                  // Étape 1
                  _buildStepCard(
                    number: "1",
                    title: "Dossier En ligne sur Campus Faso: ",
                    desc: "Déposez vos dossiers pour orientation dans une filière de votre choix de l'UTS. Puis Patienter que l'on vous notifie les résultats de l'orientation avant de procéder au paiement.",
                    icon: Icons.folder_copy_rounded,
                  ),

                  // Étape 2
                  _buildStepCard(
                    number: "2",
                    title: "Paiement",
                    desc: "Réglez vos frais via la plateforme Campus Faso (après le communiqué venant de la direction de votre UFR: Unité de Formation et de Recherche) puis télécharger vos documents (Quittance et Attestation d'inscription).",
                    icon: Icons.account_balance_wallet_rounded,
                  ),

                  // Étape 3
                  _buildStepCard(
                    number: "3",
                    title: "Validation",
                    desc: "N'oubliez pas en fin d'année de récupérer vos relevés de notes des semestres éffectués souvent nécessaire pour prendre à titre illustratif le diplôme de niveau BAC + 2.",
                    icon: Icons.verified_user_rounded,
                  ),

                  const SizedBox(height: 40),

                  // Pied de page
                  Center(
                    child: Text(
                      "Besoin d'aide ? Contactez l'administration: +226 70 44 42 94 / www.uts.bf",
                      style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({required String number, required String title, required String desc, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A237E),
            child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          Icon(icon, color: Colors.orange, size: 30),
        ],
      ),
    );
  }
}