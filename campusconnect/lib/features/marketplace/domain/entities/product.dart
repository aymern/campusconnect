class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.sellerId,
    required this.status,
    required this.isFavorite,
    required this.createdAt,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String categoryId;
  final String sellerId;
  final String status;
  final bool isFavorite;
  final DateTime createdAt;
  final String? imageUrl;

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? sellerId,
    String? status,
    bool? isFavorite,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      sellerId: sellerId ?? this.sellerId,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
