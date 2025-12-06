class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imagePath;
  final DateTime createdAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
    DateTime? createdAt,
    this.isFavorite = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  // Create from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Copy with method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imagePath,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
