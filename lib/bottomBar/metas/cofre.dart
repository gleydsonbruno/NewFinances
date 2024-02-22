import 'package:flutter/material.dart';

class Caixa extends StatefulWidget {
  @override
  _CaixaState createState() => _CaixaState();
}

class _CaixaState extends State<Caixa> {
  List<bool> selectedItems = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ícones Selecionáveis'),
      ),
      body: ListView(
        children: List.generate(5, (index) {
          return ListTile(
            title: Text('Ícone $index'),
            leading: Icon(Icons.star), // Ícone fixo para o exemplo
            onTap: () {
              setState(() {
                selectedItems[index] = !selectedItems[index];
              });
            },
            selected: selectedItems[index],
            tileColor: selectedItems[index] ? Colors.blue : null,
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para lidar com os ícones selecionados
          List<int> selectedIndexes = [];
          for (int i = 0; i < selectedItems.length; i++) {
            if (selectedItems[i]) {
              selectedIndexes.add(i);
            }
          }
          print('Ícones selecionados: $selectedIndexes');
        },
        child: Icon(Icons.check),
      ),
    );
  }
}