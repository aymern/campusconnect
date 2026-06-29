import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';

import '../../data/repositories/marketplace_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/seller.dart';

class MarketplaceProvider extends ChangeNotifier {
  MarketplaceProvider({required MarketplaceRepository repository}) : _repository = repository;

  final MarketplaceRepository _repository;

  final List<Category> _categories = const [
    Category(id: 'books', name: 'Books', icon: 'menu_book'),
    Category(id: 'tech', name: 'Tech', icon: 'devices'),
    Category(id: 'furniture', name: 'Furniture', icon: 'chair'),
    Category(id: 'services', name: 'Services', icon: 'handyman'),
  ];

  final List<Seller> _sellers = const [
    Seller(id: 'seller_1', name: 'Ava Patel', email: 'ava@campus.edu', phone: '555-1201', rating: 4.9, location: 'Phoenix Center'),
    Seller(id: 'seller_2', name: 'Liam Chen', email: 'liam@campus.edu', phone: '555-1202', rating: 4.7, location: 'Liberty Hall'),
  ];

  List<Product> _products = const [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Category> get categories => List.unmodifiable(_categories);
  List<Seller> get sellers => List.unmodifiable(_sellers);
  List<Product> get products => List.unmodifiable(_products);
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    await _repository.initialize();
    _products = await _repository.getProducts();
    if (_products.isEmpty) {
      await _seedDemoProducts();
      _products = await _repository.getProducts();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setCategory(String categoryId) async {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Product> get visibleProducts {
    final query = _searchQuery.toLowerCase();
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'all' || product.categoryId == _selectedCategory;
      final matchesQuery = product.title.toLowerCase().contains(query) || product.description.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> toggleFavorite(String productId) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index == -1) {
      return;
    }
    final current = _products[index];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    _products[index] = updated;
    await _repository.upsertProduct(updated);
    notifyListeners();
  }

  Future<void> saveProduct(Product product) async {
    final toSave = product.copyWith(id: product.id.isEmpty ? const Uuid().v4() : product.id);
    await _repository.upsertProduct(toSave);
    final index = _products.indexWhere((item) => item.id == toSave.id);
    if (index >= 0) {
      _products[index] = toSave;
    } else {
      _products.add(toSave);
    }
    notifyListeners();
  }

  Future<void> updateStatus(String productId, String status) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index == -1) {
      return;
    }
    final current = _products[index];
    final updated = current.copyWith(status: status);
    _products[index] = updated;
    await _repository.upsertProduct(updated);
    notifyListeners();
  }

  Seller? getSeller(String sellerId) {
    return _sellers.firstWhere((seller) => seller.id == sellerId, orElse: () => const Seller(id: '', name: 'Unknown seller', email: '', phone: '', rating: 0, location: ''));
  }

  Future<void> _seedDemoProducts() async {
    final demoProducts = [
      Product(
        id: 'prod_1',
        title: 'Chemistry 101 textbook bundle',
        description: 'Used textbook bundle with solution manual.',
        price: 35,
        categoryId: 'books',
        sellerId: 'seller_1',
        status: 'Available',
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Product(
        id: 'prod_2',
        title: 'MacBook charger',
        description: 'USB-C charger compatible with 2020+ MacBook models.',
        price: 24,
        categoryId: 'tech',
        sellerId: 'seller_2',
        status: 'Reserved',
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: 'prod_3',
        title: 'Desk lamp',
        description: 'Minimal desk lamp with adjustable brightness.',
        price: 18,
        categoryId: 'furniture',
        sellerId: 'seller_1',
        status: 'Sold',
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];

    for (final product in demoProducts) {
      await _repository.upsertProduct(product);
    }
  }
}
