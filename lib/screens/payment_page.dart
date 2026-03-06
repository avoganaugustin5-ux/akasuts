import 'package:flutter/material.dart';
import 'package:cinetpay/cinetpay.dart';
import 'dart:math';

class PaymentPage extends StatefulWidget {
  final String userEmail;
  final String userName;

  const PaymentPage({super.key, required this.userEmail, required this.userName});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _amountController = TextEditingController();
  String _transactionId = "";

  // Identifiants (Remplace par les tiens sur ton dashboard CinetPay)
  final String siteId = "5873528";
  final String apiKey = "128214214465d5c07c1f9c0.12521360";

  void _generateTransactionId() {
    setState(() {
      _transactionId = Random().nextInt(100000000).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement Scolarité", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Montant à payer (FCFA)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Ex: 15000",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Veuillez saisir un montant"))
                    );
                    return;
                  }

                  _generateTransactionId();

                  // Utilisation de la structure réclamée par tes erreurs (Version 2.x)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CinetPayCheckout(
                        title: "Paiement AKASUTS",
                        configData: <String, dynamic>{
                          'apikey': apiKey,
                          'site_id': siteId,
                          'notify_url': 'https://votre-site.com/notify'
                        },
                        paymentData: <String, dynamic>{
                          'transaction_id': _transactionId,
                          'amount': int.parse(_amountController.text),
                          'currency': 'XOF',
                          'designation': 'Frais de scolarité UTS',
                          'customer_name': widget.userName,
                          'customer_email': widget.userEmail,
                        },
                        waitResponse: (data) {
                          if (data['status'] == 'ACCEPTED') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Paiement réussi !"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        onError: (data) {
                          debugPrint("Erreur de paiement : $data");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur : $data"), backgroundColor: Colors.red),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                    "PAYER MAINTENANT",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}