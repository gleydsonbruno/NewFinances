import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/bottomBar/despesas.dart';
import 'package:definitivo_app_tcc/bottomBar/entradas.dart';
import 'package:definitivo_app_tcc/bottomBar/geral.dart';
import 'package:definitivo_app_tcc/bottomBar/metas/cofre.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:definitivo_app_tcc/models/banco_de_dados/database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String? userId;
  final double initialBalance;
  Home({super.key, this.userId, required this.initialBalance});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //late Saldo saldo;

  var db = DatabaseHelper();
  int currentIndex = 0;
  final pageController = PageController();

  late WalletManager _walletManager;
  @override
  void initState() {
    super.initState();
    _walletManager = WalletManager(widget.userId!);

    // Inicialize a carteira se ainda não existir
    _walletManager.getBalance();

    // Carregue e exiba o saldo
    _loadAndDisplayBalance();
  }

  // Função para carregar e exibir o saldo
  void _loadAndDisplayBalance() async {
    double currentBalance = await _walletManager.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 221, 221),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: const Color.fromARGB(255, 34, 77, 36),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: FutureBuilder<double>(
                      future: _walletManager.getBalance(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Erro ao carregar o saldo.',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          double currentBalance = snapshot.data ?? 0;
                          return Text(
                            'Saldo: R\$ $currentBalance',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    left: 8,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Caixa()));
                      },
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                Geral(),
                Despesas(
                  userId: widget.userId!,
                ),
                Entradas(userId: widget.userId!,),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.jumpToPage(index);
          });
        },
        unselectedItemColor: Colors.white.withAlpha(100),
        selectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 10, 48, 11),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                size: 40,
              ),
              label: 'Geral'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
                size: 40,
              ),
              label: 'Despesas'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.wallet_rounded,
                size: 40,
              ),
              label: 'Entradas'),
        ],
      ),
    );
  }
}

class Testwidget extends StatelessWidget {
  const Testwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: EdgeInsets.symmetric(
        vertical: 2,
      ),
      decoration: ShapeDecoration(
        color: Colors.grey, // Cor de fundo
        shape:
            CircleBorder(), // Forma do botão (pode ser ajustado conforme necessário)
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ok'),
              );
            },
          );
        },
        icon: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
