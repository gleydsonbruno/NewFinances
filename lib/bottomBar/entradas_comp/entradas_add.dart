import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:definitivo_app_tcc/bottomBar/common_widgets/custom_textfield.dart';
import 'package:definitivo_app_tcc/bottomBar/despesas_comp/components/type_choice.dart';
import 'package:definitivo_app_tcc/global/card_entrada.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:flutter/material.dart';

class EntradaAdd extends StatefulWidget {
  String userId;
  EntradaAdd({required this.userId, super.key});

  @override
  State<EntradaAdd> createState() => _EntradaAddState();
}

class _EntradaAddState extends State<EntradaAdd> {
  int selectedTypeIndex = 0;
  List<TypeChoice> listateste = [
    TypeChoice(
      icon: Icons.attach_money_outlined,
      label: 'Salário',
      color: Colors.red,
    ),
    TypeChoice(
      icon: Icons.card_giftcard,
      label: 'Presente',
      color: Colors.blue,
    ),
    TypeChoice(
      icon: Icons.api,
      label: 'Outro',
      color: Colors.green,
    ),
  ];

  TextEditingController _tituloEntradaC = TextEditingController();
  TextEditingController _valorEntradaC = TextEditingController();
  TextEditingController _tipoEntradaC = TextEditingController();
  TextEditingController _comentarioEntradaC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WalletManager _walletManager = WalletManager(widget.userId);
    DateTime actualdate = DateTime.now();
    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 7, bottom: 4, top: 15),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Título da entrada'),
                      CustomTextField(
                        icon: Icons.title,
                        controller: _tituloEntradaC,
                      ),
                      Text('Valor'),
                      CustomTextField(
                        icon: Icons.money,
                        type: TextInputType.number,
                        controller: _valorEntradaC,
                      ),
                      Text('Tipo'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(70),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(listateste.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTypeIndex = index;
                                    print(listateste[index].label);
                                  });
                                },
                                child: TypeChoice(
                                  icon: listateste[index].icon,
                                  label: listateste[index].label,
                                  color: listateste[index].color,
                                  isSelected: index == selectedTypeIndex,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Text('Comentário'),
                      CustomTextField(
                        icon: Icons.comment,
                        controller: _comentarioEntradaC,
                      ),
                      Text('Data'),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withAlpha(70),
                        ),
                        child: Center(
                          child: Text(
                            actualdate.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Excluir',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              CardEntrada _card = CardEntrada(
                                nome: _tituloEntradaC.text,
                                valor: double.parse(_valorEntradaC.text),
                                tipo: listateste[selectedTypeIndex].label,
                                comentario: _comentarioEntradaC.text,
                              );

                              _walletManager.atribuirEntrada(
                                  widget.userId, _card.valor);
                              _card.adicionarCard(_card);
                            },
                            child: const Text(
                              'Concluir',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> adicionarEntradaAoFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    print(_tituloEntradaC);
    print(_tituloEntradaC.text);
    await firestore.collection('entradas').add({
      'titulo': _tituloEntradaC.text,
      'valor': double.tryParse(_valorEntradaC.text),
      'tipo': 'random',
      'comentario': _comentarioEntradaC.text,
      'data': FieldValue.serverTimestamp(),
    });
  }
}
