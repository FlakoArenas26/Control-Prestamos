// ignore_for_file: depend_on_referenced_packages

import 'package:cryptography/cryptography.dart';
import 'package:control_prestamos/src/models/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:control_prestamos/src/models/cliente.dart';
import 'package:control_prestamos/src/models/pago.dart';
import 'dart:convert'; // Para la codificación en base64

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'control_prestamos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        deuda REAL,
        fecha_registro TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Insertar usuario predeterminado
    final hashedPassword = await _hashPassword('Admin-1029*');
    await db.insert('usuarios', {
      'username': 'Admin',
      'password': hashedPassword,
    });

    await db.execute('''
      CREATE TABLE pagos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        valor REAL,
        fecha_pago TEXT,
        FOREIGN KEY(cliente_id) REFERENCES clientes(id)
      )
    ''');
  }

  // Función para hash de contraseñas usando PBKDF2
  Future<String> _hashPassword(String password) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 128,
    );
    final secretKey = SecretKey(utf8.encode(password));
    final derivedKey = await algorithm.deriveKey(
      secretKey: secretKey,
      nonce: utf8.encode('salt'), // Puedes usar un valor de sal aleatorio
    );
    return base64.encode((await derivedKey.extract()) as List<int>);
  }

  // Función para verificar la contraseña usando PBKDF2
  Future<bool> _verifyPassword(String password, String hashedPassword) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 128,
    );
    final secretKey = SecretKey(utf8.encode(password));
    final derivedKey = await algorithm.deriveKey(
      secretKey: secretKey,
      nonce: utf8.encode('salt'), // La misma sal que usaste para el hash
    );
    final derivedKeyBytes = await derivedKey.extract();
    final hashedBytes = base64.decode(hashedPassword);
    return listEquals(derivedKeyBytes as List<int>?, hashedBytes);
  }

  // Obtener todos los clientes
  Future<List<Cliente>> getClientes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clientes');
    return List.generate(maps.length, (i) {
      return Cliente.fromMap(maps[i]);
    });
  }

  // Agregar un nuevo cliente
  Future<void> addCliente(Cliente cliente) async {
    final db = await database;
    await db.insert(
      'clientes',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener pagos por cliente
  Future<List<Pago>> getPagosByCliente(int clienteId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pagos',
      where: 'cliente_id = ?',
      whereArgs: [clienteId],
    );
    return List.generate(maps.length, (i) {
      return Pago.fromMap(maps[i]);
    });
  }

  // Agregar un nuevo pago
  Future<void> addPago(Pago pago) async {
    final db = await database;
    await db.insert(
      'pagos',
      pago.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener usuario verificando la contraseña
  Future<Usuario?> getUsuario(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      final usuario = Usuario.fromMap(maps.first);
      if (await _verifyPassword(password, usuario.password)) {
        return usuario;
      }
    }
    return null;
  }
}
