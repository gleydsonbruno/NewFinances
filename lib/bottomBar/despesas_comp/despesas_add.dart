import 'package:definitivo_app_tcc/bottomBar/common_widgets/custom_textfield.dart';
import 'package:definitivo_app_tcc/bottomBar/despesas_comp/components/type_choice.dart';
import 'package:definitivo_app_tcc/global/card_despesa.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:definitivo_app_tcc/models/banco_de_dados/database.dart';
import 'package:flutter/material.dart';

class DespesaAdd extends StatefulWidget {
  String userId;
  List<TesteID> listaDespesas;
  DespesaAdd({
    super.key,
    required this.listaDespesas,
    required this.userId,
  });

  @override
  State<DespesaAdd> createState() => _DespesaAddState();
}

class _DespesaAddState extends State<DespesaAdd> {


  int selectedTypeIndex = 0;
  List<TypeChoice> listateste = [
    TypeChoice(
      icon: Icons.house,
      label: 'Casa',
      color: Colors.red,
    ),
    TypeChoice(
      icon: Icons.layers,
      label: 'Lazer',
      color: Colors.blue,
    ),
    TypeChoice(
      icon: Icons.favorite,
      label: 'Saúde',
      color: Colors.green,
      
    ),
    TypeChoice(
      icon: Icons.menu_book,
      label: 'Educação',
      color: Colors.purple,
    ),
  ];

  bool isSelected = true;

  final _db = DatabaseHelper();
  DateTime actualdate = DateTime.now();
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  TextEditingController c = TextEditingController();
  TextEditingController d = TextEditingController();

  limpaCampos() {
    a.clear();
    b.clear();
    c.clear();
    d.clear();
  }

  listarDespesas() async {
    List itemsRecuperados = await _db.listarDespesas();
    List<TesteID> listaTemporaria = [];

    for (var despesa in itemsRecuperados) {
      TesteID item = TesteID.fromMap(despesa);
      listaTemporaria.add(item);
    }

    if (mounted) {
      setState(() {
        widget.listaDespesas = listaTemporaria;
      });
    }
    listaTemporaria = [];
  }

  @override
  Widget build(BuildContext context) {
    WalletManager _walletManager = WalletManager(widget.userId);
    List<bool> isSelected = List.generate(listateste.length, (index) => false);
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
                      
                      Text('Título da despesa'),
                      CustomTextField(
                        icon: Icons.title,
                        controller: a,
                      ),
                      Text('Valor'),
                      CustomTextField(
                        icon: Icons.money,
                        type: TextInputType.number,
                        controller: b,
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
                        controller: d,
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
                            style: const TextStyle(
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
                            onPressed: () async {
                              String title = a.text;
                              double value = double.parse(b.text);
                              String type = listateste[selectedTypeIndex].label;
                              String description = d.text;

                              CardDespesa _card = CardDespesa(
                                nome: title ,
                                valor: value,
                                tipo: type,
                                comentario: description,
                              );
                              
                              _card.adicionarCard(_card);
                              _walletManager.atribuirSaida(widget.userId, value);
                              limpaCampos();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Concluir',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
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
}
