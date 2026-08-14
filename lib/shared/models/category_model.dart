class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.priority,
    required this.isActive,
  });

  final String id;
  final String name;
  final String slug;
  final String? imageUrl;
  final int priority;
  final bool isActive;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image_url'] as String?,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) =>
      CategoryModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
      'priority': priority,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? imageUrl,
    int? priority,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      imageUrl: imageUrl ?? this.imageUrl,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
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
