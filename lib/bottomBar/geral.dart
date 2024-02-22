import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/global/card_despesa.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Geral extends StatefulWidget {
  const Geral({
    super.key,
  });

  @override
  State<Geral> createState() => _GeralState();
}

class _GeralState extends State<Geral> {
  int casa = 0;
  int lazer = 0;
  int saude = 0;
  int educacao = 0;

  double casaValor = 0;
  double lazerValor = 0;
  double saudeValor = 0;
  double educacaoValor = 0;

  List<CardDespesa> listaDespesas = [];
  late WalletManager _walletManager;

  @override
  void initState() {
    super.initState();
    listarCards();
  }

  void listarCards() async {
    List<CardDespesa> cards = await CardDespesa.listarCards();

    setState(() {
      listaDespesas = cards;
    });

    for (CardDespesa card in listaDespesas) {
      if (card.tipo == 'Casa') {
        setState(() {
          casa += 1;
          casaValor += card.valor;
        });
      } else if (card.tipo == 'Lazer') {
        setState(() {
          lazer += 1;
          lazerValor += card.valor;
        });
      } else if (card.tipo == 'Educação') {
        setState(() {
          educacao += 1;
          educacaoValor += card.valor;
        });
      } else {
        setState(() {
          saude += 1;
          saudeValor += card.valor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Barra de amostra de saldo

        //Despesas | Entrada

        //Lista de despesas\entradas
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              color: Color.fromARGB(255, 90, 139, 90),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 194, 241, 195),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                        child: Text(
                      'Maiores gastos neste mês',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.lightGreenAccent,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('despesa_cards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        return Container(
                          height: 400,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                    color:
                                        const Color.fromARGB(255, 11, 48, 78),
                                    badgeWidget: Icon(
                                      Icons.home,
                                      color: Colors.white,
                                    ),
                                    value: casaValor,
                                    title: 'R\$ $casaValor',
                                    titleStyle: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    titlePositionPercentageOffset: 0.9,
                                    radius: 150),
                                PieChartSectionData(
                                    color: const Color.fromARGB(255, 87, 14, 9),
                                    badgeWidget: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    value: saudeValor,
                                    title: 'R\$ $saudeValor',
                                    titleStyle: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    titlePositionPercentageOffset: 0.9,
                                    radius: 150),
                                PieChartSectionData(
                                    color: Color.fromARGB(255, 115, 122, 12),
                                    badgeWidget: Icon(
                                      Icons.menu_book,
                                      color: Colors.white,
                                    ),
                                    value: educacaoValor,
                                    title: 'R\$ $educacaoValor',
                                    titleStyle: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    titlePositionPercentageOffset: 0.9,
                                    radius: 150),
                                PieChartSectionData(
                                  color: const Color.fromARGB(255, 11, 63, 12),
                                  badgeWidget: Icon(
                                    Icons.layers,
                                    color: Colors.white,
                                  ),
                                  value: lazerValor,
                                  title: 'R\$ $lazerValor',
                                  titleStyle: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  titlePositionPercentageOffset: 0.9,
                                  radius: 150,
                                ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 0,
                              startDegreeOffset: -90,
                            ),
                          ),
                        );
                      }),
                  const Divider(
                    thickness: 2,
                    color: Colors.lightGreenAccent,
                  ),
                  /*
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Column(
                        children: [
                          Text('Lazer: $lazer / R\$ $lazerValor'),
                          Text('Casa: $casa / R\$ $casaValor'),
                          Text('Saúde: $saude / R\$ $saudeValor'),
                          Text('Educação: $educacao / R\$ $educacaoValor'),
                        ],
                      ),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
