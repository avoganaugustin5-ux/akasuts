import 'package:flutter/material.dart';

/// Un Widget unique pour afficher le logo de AKASUTS.
/// Tu peux changer le type (design1, design2, design3) et la taille.
class AppLogo extends StatelessWidget {
  final double size;
  final LogoDesign design;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100,
    this.design = LogoDesign.design1,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _getLogoWidget(),
        if (showText) ...[
          const SizedBox(height: 10),
          Text(
            "AKASUTS",
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E),
              letterSpacing: 2,
            ),
          ),
          Text(
            "Université Thomas Sankara",
            style: TextStyle(
              fontSize: size * 0.1,
              color: Colors.grey[600],
              letterSpacing: 1,
            ),
          ),
        ]
      ],
    );
  }

  Widget _getLogoWidget() {
    switch (design) {
      case LogoDesign.design1: return _buildDesign1();
      case LogoDesign.design2: return _buildDesign2();
      case LogoDesign.design3: return _buildDesign3();
    }
  }

  // --- DESIGN 1 : Le Flambeau du Savoir (Minimaliste & Moderne) ---
  Widget _buildDesign1() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E), // Bleu UTS
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size * 0.2),
      child: Center(
        child: Icon(
          Icons.local_library_rounded, // Icône de bibliothèque/livre
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }

  // --- DESIGN 2 : L'Inspiration d'Art Africain (Moderne & Local) ---
  Widget _buildDesign2() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.rocket_launch_rounded, // Icône d'inspiration
              color: Colors.white,
              size: size * 0.4,
            ),
            const Text(
              "UTS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DESIGN 3 : L'Insigne Numérique (Web & Mobile) ---
  Widget _buildDesign3() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.local_library_rounded, // Icône d'enseignement
              color: Colors.white,
              size: size * 0.35,
            ),
            const Spacer(),
            Icon(
              Icons.phone_iphone_rounded, // Icône de mobile/numérique
              color: Colors.white,
              size: size * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}

// Les différents designs possibles.
enum LogoDesign {
  design1,
  design2,
  design3,
}