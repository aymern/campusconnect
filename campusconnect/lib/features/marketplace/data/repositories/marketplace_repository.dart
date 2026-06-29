import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/seller.dart';

abstract class MarketplaceRepository {
  Future<void> initialize();
  Future<List<Category>> getCategories();
  Future<List<Seller>> getSellers();
  Future<List<Product>> getProducts();
  Future<void> upsertProduct(Product product);
  Future<void> deleteProduct(String id);
}

class SqliteMarketplaceRepository implements MarketplaceRepository {
  SqliteMarketplaceRepository({Database? database}) : _database = database;

  final Database? _database;
  Database? _db;

  @override
  Future<void> initialize() async {
    _db ??= _database ?? await openDatabase(
      p.join(await getDatabasesPath(), 'campusconnect_marketplace.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            category_id TEXT NOT NULL,
            seller_id TEXT NOT NULL,
            status TEXT NOT NULL,
            is_favorite INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            image_url TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE sellers (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT NOT NULL,
            rating REAL NOT NULL,
            location TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE categories (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            icon TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<Category>> getCategories() async {
    await initialize();
    final rows = await _db!.query('categories');
    return rows.map((row) => Category(
      id: row['id'] as String,
      name: row['name'] as String,
      icon: row['icon'] as String,
    )).toList(growable: false);
  }

  @override
  Future<List<Seller>> getSellers() async {
    await initialize();
    final rows = await _db!.query('sellers');
    return rows.map((row) => Seller(
      id: row['id'] as String,
      name: row['name'] as String,
      email: row['email'] as String,
      phone: row['phone'] as String,
      rating: (row['rating'] as num).toDouble(),
      location: row['location'] as String,
    )).toList(growable: false);
  }

  @override
  Future<List<Product>> getProducts() async {
    await initialize();
    final rows = await _db!.query('products');
    return rows.map((row) => Product(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      price: (row['price'] as num).toDouble(),
      categoryId: row['category_id'] as String,
      sellerId: row['seller_id'] as String,
      status: row['status'] as String,
      isFavorite: (row['is_favorite'] as int) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
      imageUrl: row['image_url'] as String?,
    )).toList(growable: false);
  }

  @override
  Future<void> upsertProduct(Product product) async {
    await initialize();
    await _db!.insert(
      'products',
      {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'category_id': product.categoryId,
        'seller_id': product.sellerId,
        'status': product.status,
        'is_favorite': product.isFavorite ? 1 : 0,
        'created_at': product.createdAt.toIso8601String(),
        'image_url': product.imageUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await initialize();
    await _db!.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
