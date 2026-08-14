import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/shared/models/category_model.dart';
import 'package:vender_app/shared/models/product_model.dart';

class AddProductState {
  final bool isLoading;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<VendorProductModel> vendorProducts;
  final String searchQuery;

  const AddProductState({
    this.isLoading = false,
    this.categories = const [],
    this.selectedCategory,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.vendorProducts = const [],
    this.searchQuery = '',
  });

  AddProductState copyWith({
    bool? isLoading,
    List<CategoryModel>? categories,
    CategoryModel? selectedCategory,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<VendorProductModel>? vendorProducts,
    String? searchQuery,
    bool clearCategory = false,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      vendorProducts: vendorProducts ?? this.vendorProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
