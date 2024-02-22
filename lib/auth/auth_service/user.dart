import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isTelaExibida(String userId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('usuarios').doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['input_saldo'] ?? false;
    }

    return false;
  }

  Future<void> marcarTelaExibida(String userId) async {
    await _firestore.collection('usuarios').doc(userId).update({
      'input_saldo': true,
    });
  }
}
