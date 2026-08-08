import '../widgets/product_status_chip.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String image;
  final ProductStatus status;
}
