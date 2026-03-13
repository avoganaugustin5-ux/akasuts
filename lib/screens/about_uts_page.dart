import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUtsPage extends StatelessWidget {
  const AboutUtsPage({super.key});

  // Fonction pour appeler le numéro directement
  Future<void> _makeCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '70444294');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("À Propos de l'UTS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/campus.jpg', fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notre Mission",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 10),
                  const Text(
                    "L'UTS a pour mission fondamentale l’élaboration et la transmission de la connaissance pour la formation des hommes et des femmes, afin de répondre aux besoins de la nation.",
                    style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    children: [
                      _buildInfoStat("1 890 ha", "Superficie", Icons.map),
                      _buildInfoStat("70", "Filières LMD", Icons.school),
                      _buildInfoStat("2007", "Création", Icons.event),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text("Unités de Formation & Instituts",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  _buildComponentTile("UFR SJP", "Sciences Juridiques et Politiques"),
                  _buildComponentTile("UFR SEG", "Sciences Économiques et de Gestion"),
                  _buildComponentTile("UFR ST", "Sciences et Techniques"),
                  _buildComponentTile("IUFIC", "Formation Initiale et Continue"),
                  _buildComponentTile("IFOAD", "Formation Ouverte à Distance"),

                  const SizedBox(height: 25),

                  const Text("Contact & Accès",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.location_on, color: Colors.red),
                          title: Text("Adresse"),
                          subtitle: Text("12 BP 417 Ouagadougou 12, Saaba"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.green),
                          title: const Text("Téléphone"),
                          subtitle: const Text("+226 70 44 42 94"),
                          onTap: _makeCall,
                        ),
                        const ListTile(
                          leading: Icon(Icons.access_time, color: Colors.orange),
                          title: Text("Horaires"),
                          subtitle: Text("Ouvert · Ferme à 17:00"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStat(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildComponentTile(String code, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(8)),
            child: Text(code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}