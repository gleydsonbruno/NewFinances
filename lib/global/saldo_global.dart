import 'package:cloud_firestore/cloud_firestore.dart';

class WalletManager {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  WalletManager(this.userId);

  // Função para obter o saldo do Firestore
  Future<double> getBalance() async {
    // Verifica se a carteira já existe. Se não existir, cria uma nova.
    await _initializeWalletIfNotExists();

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      return (documentSnapshot['balance'] ?? 0.0).toDouble();
    } else {
      // Se o documento não existe, pode inicializar o saldo como 0.0 ou outro valor padrão
      return 0.0;
    }
  }

  // Função para inicializar a carteira se ela não existir
  Future<void> _initializeWalletIfNotExists() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .get();

    if (!documentSnapshot.exists) {
      // Se o documento não existe, cria uma carteira com um saldo inicial
      await FirebaseFirestore.instance.collection('wallets').doc(userId).set({
        'balance': 0, // ou outro valor inicial desejado
      });
    }
  }

  // Função para atualizar o saldo no Firestore
  Future<void> updateBalance(double newBalance) async {
    await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .set({'balance': newBalance});
  }

  Future<void> atribuirEntrada(String userId, double amount) async {
    try {
      await _firestore.collection('wallets').doc(userId).update({
        'balance': FieldValue.increment(amount),
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> atribuirSaida(String userId, double amount) async {
    try {
      await _firestore.collection('wallets').doc(userId).update({
        'balance': FieldValue.increment(-amount),
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> adicionarCategoria(String tipo) async {
    await FirebaseFirestore.instance.collection('categorias').add({
      'tipo': tipo,
      // outros campos que você desejar adicionar
    });
  }
}
