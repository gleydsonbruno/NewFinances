import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Cadastro
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      //tela input saldo
      await _firestore.collection('usuarios').doc(user!.uid).set({
        'input_saldo': false,
      });

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //Login
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      return user?.uid;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //Logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  

  Future<void> atribuirEntrada(String userId, double amount) async {
    try {
      await _firestore.collection('wallet').doc(userId).update({
        'balance': FieldValue.increment(amount),
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> atribuirSaida(String userId, double amount) async {
    try {
      await _firestore.collection('wallet').doc(userId).update({
        'balance': FieldValue.increment(-amount),
      });
    } catch (error) {
      print(error.toString());
    }
  }
  
}
