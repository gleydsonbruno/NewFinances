import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/bottomBar/despesas_comp/despesa_card.dart';
import 'package:definitivo_app_tcc/bottomBar/despesas_comp/despesas_add.dart';
import 'package:definitivo_app_tcc/global/card_despesa.dart';
import 'package:definitivo_app_tcc/models/banco_de_dados/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Despesas extends StatefulWidget {
  String userId;
  Despesas({
    super.key,
    required this.userId,
  });

  @override
  State<Despesas> createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  RxList<TesteID> listaDespesas = <TesteID>[].obs;
  final _db = DatabaseHelper();

  listarDespesas() async {
    List itemsRecuperados = await _db.listarDespesas();
    RxList<TesteID> listaTemporaria = <TesteID>[].obs;

    for (var despesa in itemsRecuperados) {
      TesteID item = TesteID.fromMap(despesa);
      listaTemporaria.add(item);
    }

    if (mounted) {
      setState(() {
        listaDespesas = listaTemporaria;
      });
    }
    listaTemporaria = <TesteID>[].obs;
  }

  @override
  void initState() {
    super.initState();
    listarDespesas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(150),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(150),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('despesa_cards')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var cards = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      var cardData =
                          cards[index].data() as Map<String, dynamic>;

                      if (cardData != null) {
                        var card = CardDespesa(
                          nome: cardData['nome'] ??
                              "",
                          valor: cardData['valor'] ??
                              0.0, 
                          tipo: cardData['tipo'] ??
                              "", 
                          comentario: cardData['comentario'] ??
                              "", 
                        );

                        return DespesaCard(
                            despesaItem: card, userId: widget.userId);
                      } else {
                        return SizedBox(); 
                      }
                    });
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
                  return DespesaAdd(
                    userId: widget.userId,
                    listaDespesas: listaDespesas,
                  );
                });
          },
          backgroundColor: Colors.black.withAlpha(150),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
