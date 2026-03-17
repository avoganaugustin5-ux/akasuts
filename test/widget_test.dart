import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akasuts/main.dart'; // Vérifie que ce chemin est correct

void main() {
  testWidgets('Test de démarrage AKASUTS', (WidgetTester tester) async {
    // 1. On remplace UniversityApp par MyApp (ton vrai nom de classe)
    await tester.pumpWidget(const MyApp());

    // 2. Comme ton app affiche un CircularProgressIndicator au début (StreamBuilder),
    // on vérifie simplement qu'il trouve bien un widget de chargement.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}