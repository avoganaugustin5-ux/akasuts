import 'package:flutter/material.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comment s'inscrire ?"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image d'en-tête (Optionnelle ou Logo)
            Container(
              height: 150,
              width: double.infinity,
              color: const Color(0xFF1A237E).withOpacity(0.1),
              child: const Icon(Icons.school, size: 80, color: Color(0xFF1A237E)),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Procédure d'inscription à l'UTS",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Suivez les étapes ci-dessous pour finaliser votre inscription administrative et pédagogique.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // ÉTAPE 1
                  _buildStepItem(
                    number: "1",
                    title: "Dépôt du dossier physique",
                    description: "Rendez-vous à la scolarité centrale avec vos diplômes originaux et les copies légalisées.",
                    icon: Icons.folder_shared,
                  ),

                  // ÉTAPE 2
                  _buildStepItem(
                    number: "2",
                    title: "Paiement de la scolarité",
                    description: "Effectuez votre paiement via l'application (section Paiement) ou à la banque partenaire.",
                    icon: Icons.payments_outlined,
                  ),

                  // ÉTAPE 3
                  _buildStepItem(
                    number: "3",
                    title: "Choix des unités d'enseignement",
                    description: "Connectez-vous à votre espace pour valider vos matières pour le semestre en cours.",
                    icon: Icons.app_registration,
                  ),

                  // ÉTAPE 4
                  _buildStepItem(
                    number: "4",
                    title: "Retrait de la carte d'étudiant",
                    description: "Une fois le dossier validé, retirez votre carte au service de la scolarité.",
                    icon: Icons.badge_outlined,
                  ),

                  const SizedBox(height: 30),

                  // Note d'information
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Attention : Tout dossier incomplet sera rejeté. Vérifiez bien vos documents.",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  // Widget pour construire chaque étape proprement
  Widget _buildStepItem({required String number, required String title, required String description, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A237E),
            radius: 18,
            child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFF1A237E).withOpacity(0.5)),
        ],
      ),
    );
  }
}