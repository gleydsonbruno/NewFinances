import 'package:cloud_firestore/cloud_firestore.dart';

class CardEntrada {
  String nome;
  double valor;
  String tipo;
  String comentario;

  CardEntrada(
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

  Future<String> adicionarCard(CardEntrada card) async {
    var docRef = await FirebaseFirestore.instance
        .collection('entrada_cards')
        .add(card.toMap());

    String cardId = docRef.id;
    return cardId;
  }

  Future<void> excluirCard(String cardId) async {
    try {
      await FirebaseFirestore.instance.collection('cards').doc(cardId).delete();
      print('Card $cardId excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir o card: $e');
      // Trate o erro conforme necessário
    }
  }

  static Future<List<CardEntrada>> listarCards() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('entrada_cards').get();

      List<CardEntrada> listaCards = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CardEntrada.fromMap(data);
      }).toList();

      return listaCards;
    } catch (e) {
      print('Erro ao listar cards: $e');
      return [];
    }
  }

  CardEntrada.fromMap(Map<String, dynamic> map)
      : nome = map['nome'],
        valor = (map['valor'] as num).toDouble(),
        tipo = map['tipo'],
        comentario = map['comentario'];
}
