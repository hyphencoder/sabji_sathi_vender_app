class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.description,
    required this.priority,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? description;
  final int priority;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      imageUrl: map['image_url'] as String?,
      description: map['description'] as String?,
      priority: (map['priority'] ?? 0) as int,
      isActive: (map['is_active'] ?? true) as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
      'description': description,
      'priority': priority,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? imageUrl,
    String? description,
    int? priority,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CategoryModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
