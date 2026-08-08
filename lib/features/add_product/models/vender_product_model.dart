class VendorProductModel {
  const VendorProductModel({
    this.id,
    required this.vendorId,
    required this.productId,
    required this.sellingPrice,
    required this.stock,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String vendorId;
  final String productId;
  final double sellingPrice;
  final int stock;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VendorProductModel.fromMap(Map<String, dynamic> map) {
    return VendorProductModel(
      id: map['id'] as String?,
      vendorId: map['vendor_id'] as String,
      productId: map['product_id'] as String,
      sellingPrice: (map['selling_price'] as num).toDouble(),
      stock: map['stock'] as int,
      isAvailable: map['is_available'] as bool,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendor_id': vendorId,
      'product_id': productId,
      'selling_price': sellingPrice,
      'stock': stock,
      'is_available': isAvailable,
    };
  }

  VendorProductModel copyWith({
    String? id,
    String? vendorId,
    String? productId,
    double? sellingPrice,
    int? stock,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorProductModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'VendorProductModel(id: $id, vendorId: $vendorId, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VendorProductModel &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
