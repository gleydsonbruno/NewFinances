import 'package:definitivo_app_tcc/global/card_despesa.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:definitivo_app_tcc/models/appdata.dart';
import 'package:definitivo_app_tcc/models/banco_de_dados/database.dart';
import 'package:definitivo_app_tcc/models/despesa_model.dart';
import 'package:definitivo_app_tcc/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:definitivo_app_tcc/models/appdata.dart' as appData;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class DespesaCard extends StatefulWidget {
  String userId;
  final CardDespesa despesaItem;

  DespesaCard({
    super.key,
    required this.despesaItem,
    required this.userId,
  });

  @override
  State<DespesaCard> createState() => _DespesaCardState();
}

class _DespesaCardState extends State<DespesaCard> {

  
  final _db = DatabaseHelper();
  final UtilServices utilServices = UtilServices();




  @override
  Widget build(BuildContext context) {
    WalletManager _walletManager = WalletManager(widget.userId);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          Icons.type_specimen,
          size: 40,
        ),
        title: Text(
          widget.despesaItem.nome,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          '- ${utilServices.priceToCurrency(widget.despesaItem.valor)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.read_more),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('${widget.despesaItem.comentario}'),
                  );
                });
          },
        ),
      ),
    );
  }
}

