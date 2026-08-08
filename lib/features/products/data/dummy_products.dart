import '../models/product_model.dart';
import '../widgets/product_status_chip.dart';

class DummyProducts {
  static const List<ProductModel> products = [
    ProductModel(
      id: "1",
      name: "Fresh Tomato",
      category: "Vegetables",
      price: 40,
      stock: 25,
      image: "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=500",
      status: ProductStatus.inStock,
    ),

    ProductModel(
      id: "2",
      name: "Potato",
      category: "Vegetables",
      price: 30,
      stock: 8,
      image:
          "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500",
      status: ProductStatus.lowStock,
    ),

    ProductModel(
      id: "3",
      name: "Onion",
      category: "Vegetables",
      price: 35,
      stock: 0,
      image:
          "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=500",
      status: ProductStatus.outOfStock,
    ),

    ProductModel(
      id: "4",
      name: "Carrot",
      category: "Root",
      price: 60,
      stock: 14,
      image:
          "https://images.unsplash.com/photo-1447175008436-054170c2e979?w=500",
      status: ProductStatus.inStock,
    ),
  ];
}
