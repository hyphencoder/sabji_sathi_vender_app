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
  final String? categoryName;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      unit: json['unit'] as String,
      image: json['image'] as String?,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      categoryName: json['categories'] != null
          ? json['categories']['name'] as String?
          : null,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) =>
      ProductModel.fromJson(map);

  Map<String, dynamic> toJson() {
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
    };
  }

  Map<String, dynamic> toMap() => toJson();

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
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
