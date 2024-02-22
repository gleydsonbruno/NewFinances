import 'package:cloud_firestore/cloud_firestore.dart';

class CardDespesa {
  String nome;
  double valor;
  String tipo;
  String comentario;

  CardDespesa(
      {required this.nome,
      required this.valor,
      required this.tipo,
      required this.comentario});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'valor': valor,
      'tipo': tipo,
      'comentario': comentario,
    };
  }

  Future<String> adicionarCard(CardDespesa card) async {
    var docRef = await FirebaseFirestore.instance
        .collection('despesa_cards')
        .add(card.toMap());

    String cardId = docRef.id;
    return cardId;
  }

  static Future<List<CardDespesa>> listarCards() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('despesa_cards').get();

      List<CardDespesa> listaCards = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardDespesa.fromMap(data);
      }).toList();

      return listaCards;
    } catch (e) {
      print('Erro ao listar cards: $e');
      return [];
    }
  }

  CardDespesa.fromMap(Map<String, dynamic> map)
      : nome = map['nome'],
        valor = (map['valor'] as num).toDouble(),
        tipo = map['tipo'],
        comentario = map['comentario'];
}
