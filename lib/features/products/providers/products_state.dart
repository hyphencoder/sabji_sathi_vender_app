import 'package:vender_app/shared/models/category_model.dart';
import 'package:vender_app/shared/models/vendor_product_details_model.dart';

class ProductsState {
  const ProductsState({
    this.isLoading = false,
    this.categories = const [],
    this.products = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.error,
  });

  final bool isLoading;

  final List<CategoryModel> categories;

  final List<VendorProductDetailsModel> products;

  final CategoryModel? selectedCategory;

  final String searchQuery;

  final String? error;

  ProductsState copyWith({
    bool? isLoading,
    List<CategoryModel>? categories,
    List<VendorProductDetailsModel>? products,
    CategoryModel? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    String? error,
    bool clearError = false,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
