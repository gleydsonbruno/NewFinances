import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:definitivo_app_tcc/home.dart';
import 'package:definitivo_app_tcc/models/banco_de_dados/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputSaldo extends StatefulWidget {
  
  
  String? userId;
  InputSaldo(this.userId);

  @override
  State<InputSaldo> createState() => _InputSaldoState();
}

class _InputSaldoState extends State<InputSaldo> {

 
  //firebase
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 

  void createWallet(double saldo) {
    firestore.collection('wallet').add({
      'wallet': saldo,
    });
  }


  //firebase
  TextEditingController saldoC = TextEditingController();
  final db = DatabaseHelper();
  double saldoAtual = 0.0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Seu saldo atual:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25, left: 55, right: 55),
            child: TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              controller: saldoC,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 75,
              vertical: 25,
            ),
            child: ElevatedButton(
              onPressed: () async {
                double valorInicial = double.parse(saldoC.text);
                WalletManager walletManager = WalletManager(widget.userId!);
                walletManager.updateBalance(valorInicial);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Home(userId: widget.userId, initialBalance: double.parse(saldoC.text)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 33, 90, 35),
                padding: EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
