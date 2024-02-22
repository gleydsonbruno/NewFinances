import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/bottomBar/entradas_comp/entrada_card.dart';
import 'package:definitivo_app_tcc/bottomBar/entradas_comp/entradas_add.dart';
import 'package:definitivo_app_tcc/global/card_entrada.dart';
import 'package:definitivo_app_tcc/models/appdata.dart';
import 'package:flutter/material.dart';
import 'package:definitivo_app_tcc/models/appdata.dart' as appData;

class Entradas extends StatefulWidget {
  String userId;
  Entradas({
    required this.userId,
    super.key,
  });

  @override
  State<Entradas> createState() => _EntradasState();
}

class _EntradasState extends State<Entradas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(150),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(150),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('entrada_cards')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var cards = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    var cardData = cards[index].data() as Map<String, dynamic>;
                    var card = CardEntrada(
                      nome: cardData['nome'],
                      valor: cardData['valor'],
                      tipo: cardData['tipo'],
                      comentario: cardData['comentario'],
                    );

                    return EntradaCard(entradaItem: card);
                  },
                );
              },
            )),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return EntradaAdd(userId: widget.userId);
                  });
            },
            backgroundColor: Colors.black.withAlpha(150),
            child: Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}
