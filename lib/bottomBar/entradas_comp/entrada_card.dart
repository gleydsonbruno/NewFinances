import 'package:definitivo_app_tcc/global/card_entrada.dart';
import 'package:definitivo_app_tcc/models/appdata.dart';
import 'package:definitivo_app_tcc/models/entrada_model.dart';
import 'package:definitivo_app_tcc/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:definitivo_app_tcc/models/appdata.dart' as appData;

class EntradaCard extends StatefulWidget {
  final CardEntrada entradaItem;

  EntradaCard({
    super.key,
    required this.entradaItem,

  });

  @override
  State<EntradaCard> createState() => _EntradaCardState();
}

class _EntradaCardState extends State<EntradaCard> {
  final UtilServices utilServices = UtilServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(Icons.type_specimen, size: 40),
        title: Text(
          widget.entradaItem.nome,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
           '+ ${utilServices.priceToCurrency(widget.entradaItem.valor)}', style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.read_more),
          onPressed: () {
             showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('${widget.entradaItem.comentario}'),
                  );
                });
          },
        ),
      ),
    );
  }
}
