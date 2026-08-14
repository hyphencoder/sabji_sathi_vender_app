class VendorProductModel {
  const VendorProductModel({
    this.id,
    required this.vendorId,
    required this.productId,
    required this.sellingPrice,
    required this.mrp,
    required this.discountPrice,
    required this.stock,
    required this.minOrderQty,
    required this.maxOrderQty,
    required this.sku,
    required this.status,
    required this.isAvailable,
    required this.isFeatured,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String vendorId;
  final String productId;
  final double sellingPrice;
  final double mrp;
  final double discountPrice;
  final int stock;
  final int minOrderQty;
  final int maxOrderQty;
  final String sku;
  final String status;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VendorProductModel.fromJson(Map<String, dynamic> json) {
    return VendorProductModel(
      id: json['id'] as String?,
      vendorId: json['vendor_id'] as String,
      productId: json['product_id'] as String,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num).toDouble(),
      stock: json['stock'] as int,
      minOrderQty: json['min_order_qty'] as int,
      maxOrderQty: json['max_order_qty'] as int,
      sku: json['sku'] as String,
      status: json['status'] as String,
      isAvailable: json['is_available'] as bool,
      isFeatured: json['is_featured'] as bool,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  factory VendorProductModel.fromMap(Map<String, dynamic> map) =>
      VendorProductModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'product_id': productId,
      'selling_price': sellingPrice,
      'mrp': mrp,
      'discount_price': discountPrice,
      'stock': stock,
      'min_order_qty': minOrderQty,
      'max_order_qty': maxOrderQty,
      'sku': sku,
      'status': status,
      'is_available': isAvailable,
      'is_featured': isFeatured,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  Map<String, dynamic> toVendorUpdateJson() {
    return {
      'selling_price': sellingPrice,
      'mrp': mrp,
      'discount_price': discountPrice,
      'stock': stock,
      'min_order_qty': minOrderQty,
      'max_order_qty': maxOrderQty,
      'sku': sku,
      'is_available': isAvailable,
    };
  }

  VendorProductModel copyWith({
    String? id,
    String? vendorId,
    String? productId,
    double? sellingPrice,
    double? mrp,
    double? discountPrice,
    int? stock,
    int? minOrderQty,
    int? maxOrderQty,
    String? sku,
    String? status,
    bool? isAvailable,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorProductModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      mrp: mrp ?? this.mrp,
      discountPrice: discountPrice ?? this.discountPrice,
      stock: stock ?? this.stock,
      minOrderQty: minOrderQty ?? this.minOrderQty,
      maxOrderQty: maxOrderQty ?? this.maxOrderQty,
      sku: sku ?? this.sku,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
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
