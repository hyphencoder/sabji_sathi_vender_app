class ProductModel {
  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.shortDescription,
    this.description,
    required this.unit,
    this.image,
    required this.priority,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
  });

  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? shortDescription;
  final String? description;
  final String unit;
  final String? image;
  final int priority;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Join se aayega (products -> categories)
  final String? categoryName;

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      shortDescription: map['short_description'] as String?,
      description: map['description'] as String?,
      unit: map['unit'] as String,
      image: map['image'] as String?,
      priority: map['priority'] ?? 0,
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      categoryName: map['categories'] != null
          ? map['categories']['name'] as String?
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'description': description,
      'unit': unit,
      'image': image,
      'priority': priority,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    String? unit,
    String? image,
    int? priority,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      image: image ?? this.image,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
