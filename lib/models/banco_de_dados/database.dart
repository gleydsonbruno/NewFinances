import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  Database? _database;


  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal() {
    initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _criarBanco,
    );
  }

  Future<void> _criarBanco(Database db, int version) async {
    List<String> queries = [
      'CREATE TABLE despesas (id INTEGER PRIMARY KEY, title TEXT, value DOUBLE, description TEXT, type TEXT);',
      'CREATE TABLE entradas (id INTEGER PRIMARY KEY, title TEXT, value DOUBLE, description TEXT, type TEXT);',
      'CREATE TABLE saldo_usuario (id INTEGER PRIMARY KEY, saldo REAL DEFAULT 0);'
    ];

    for (String query in queries) {
      await db.execute(query);
    }
  }

  //Quando implementar isso, remover esse comentário vvvvvv
  obterSaldoUsuario() async {
    Database db = await database;
    String sql = 'SELECT saldo FROM saldo_usuario';
    List<Map<String, dynamic>> saldo = await db.rawQuery(sql);

    if (saldo.isNotEmpty) {
      double saldoValor = saldo[0]['saldo'];
      return saldoValor;
    } else {
      return 0;
    }

  }

  Future<int> atualizarSaldo(Saldo valor) async {
    Database db = await database;
    return await db.insert('saldo_usuario', valor.toMap());
  }

  Future<List<Map<String, dynamic>>> listar() async {
    Database db = await database;
    return await db.query('despesas');
  }

  Future<int> inserir(TesteID data) async {
    Database db = await database;
    int resultado = await db.insert('despesas', data.toMap());

    List<Map<String, dynamic>> result = await db.query('despesas');
    result.forEach((row) {
      print(row);
    });
    return resultado;
  }

  listarDespesas() async {
    var bancoDados = await database;
    String sql = 'SELECT * FROM despesas';
    List items = await bancoDados.rawQuery(sql);
    return items;
  }

  Future<int> removerDespesa(int id) async {
    var bancoDados = await database;
    return await bancoDados.delete(
      'despesas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class TesteID {
  int? id;
  late String title;
  late double value;
  late String description;
  late String? type;

  TesteID(this.id, this.title, this.value, this.description, this.type);

  TesteID.fromMap(Map map) {
    this.id = map['id'];
    this.title = map['title'];
    this.value = map['value'];
    this.description = map['description'];
    this.type = map['type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': this.title,
      'value': this.value,
      'description': this.description,
      'type': this.type,
    };

    if (this.id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}

class Saldo {
  static int? _id;
  late double saldo;

  Saldo(this.saldo) {
    if (_id == null) {
      _id = 1;
    }
    this.id = _id;
    _id = id! + 1;
  }

  int? id;

  Saldo.fromMap(Map map) {
    this.saldo = map['saldo'];
    this.id = map['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'saldo': this.saldo,
    };
    if (this.id != null) {
      map['id'] = this.id;
    }

    return map;
  }

  Future<void> createWallet() async {
    await FirebaseFirestore.instance.collection('wallet').doc().set({'wallet': saldo});
  }

  Future<void> loadSaldo() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('wallet').doc().get();
  }
}
