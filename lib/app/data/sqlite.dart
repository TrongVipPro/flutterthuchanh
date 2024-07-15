// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_application_1/app/model/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/app/model/bill.dart';
// import 'package:flutter_application_1/app/model/bill_detail.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_cart.db');
    print("Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(path, onCreate: _onCreate, version: 1
      // ,
      // onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
          'productID INTEGER PRIMARY KEY, name TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER)',
    );

    await db.execute(
      'CREATE TABLE Bill('
          'id TEXT PRIMARY KEY, fullName TEXT, dateCreated TEXT, total INTEGER)',
    );

    await db.execute(
      'CREATE TABLE BillDetail('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, billId TEXT, productId INTEGER, productName TEXT, imageUrl TEXT, price INTEGER, count INTEGER, total INTEGER,'
          'FOREIGN KEY(billId) REFERENCES Bill(id) ON DELETE CASCADE)',
    );
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await _databaseService.database;
    await db.insert('Cart', productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    print("product: ${productModel.toJson()}");
  }

  Future<List<Cart>> products() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    print("fetched products : $maps");
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart> product(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('product', where: 'id = ?', whereArgs: [id]);
    return Cart.fromMap(maps[0]);
  }

  Future<void> minus(Cart product) async {
    final db = await _databaseService.database;
    if (product.count > 1) product.count--;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> add(Cart product) async {
    final db = await _databaseService.database;
    product.count++;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateProduct(Cart productModel) async {
    final db = await database;
    await db.update(
      'Cart',
      productModel.toMap(),
      where: 'productID = ?',
      whereArgs: [productModel.productID],
    );
  }

  Future<void> clear() async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'count > 0'
    );
  }

  Future<void> insertBill(BillModel bill) async {
    final db = await _databaseService.database;
    await db.insert(
      'Bill',
      bill.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var item in bill.items) {
      await db.insert(
        'BillDetail',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<BillModel>> getBills() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> billMaps = await db.query('Bill');
    List<BillModel> bills = [];
    for (var billMap in billMaps) {
      final List<Map<String, dynamic>> billDetailMaps = await db.query(
        'BillDetail',
        where: 'billId = ?',
        whereArgs: [billMap['id']],
      );
      List<BillDetailModel> billDetails = billDetailMaps.map((e) => BillDetailModel.fromJson(e)).toList();
      bills.add(BillModel.fromJson(billMap)..items = billDetails);
    }
    return bills;
  }
}