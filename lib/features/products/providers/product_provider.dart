import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/services/category_service.dart';
import 'package:vender_app/features/add_product/services/vendor_product_service.dart';
import 'package:vender_app/shared/models/category_model.dart';
import 'package:vender_app/shared/models/vendor_product_details_model.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(),
);

class ProductsState {
  const ProductsState({
    this.isLoading = false,
    this.categories = const [],
    this.products = const [],
    this.filteredProducts = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.error,
  });

  final bool isLoading;
  final List<CategoryModel> categories;
  final List<VendorProductDetailsModel> products;
  final List<VendorProductDetailsModel> filteredProducts;
  final CategoryModel? selectedCategory;
  final String searchQuery;
  final String? error;

  ProductsState copyWith({
    bool? isLoading,
    List<CategoryModel>? categories,
    List<VendorProductDetailsModel>? products,
    List<VendorProductDetailsModel>? filteredProducts,
    CategoryModel? selectedCategory,
    String? searchQuery,
    String? error,
    bool clearError = false,
    bool clearCategory = false,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier() : super(const ProductsState());

  final VendorProductService _vendorProductService = VendorProductService();
  final CategoryService _categoryService = CategoryService();

  /// Load Products
  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final vendorId = Supabase.instance.client.auth.currentUser!.id;

      final categories = await _categoryService.getCategories();

      final products = await _vendorProductService.getVendorProductsWithDetails(
        vendorId,
      );

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        products: products,
        filteredProducts: products,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadProducts();
  }

  /// Select Category
  void selectCategory(CategoryModel? category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  /// Clear Category
  void clearCategory() {
    state = state.copyWith(clearCategory: true);
    _applyFilters();
  }

  /// Search Products
  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Apply Filters
  void _applyFilters() {
    List<VendorProductDetailsModel> products = List.from(state.products);

    /// Category Filter
    if (state.selectedCategory != null) {
      products = products.where((e) {
        return e.product.categoryId == state.selectedCategory!.id;
      }).toList();
    }

    /// Search Filter
    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.toLowerCase();

      products = products.where((e) {
        return e.product.name.toLowerCase().contains(query);
      }).toList();
    }

    state = state.copyWith(filteredProducts: products);
  }

  /// Delete Product
  Future<void> deleteProduct(String vendorProductId) async {
    try {
      await _vendorProductService.deleteVendorProduct(vendorProductId);

      // Reload products after delete
      await loadProducts();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> updateProduct({
    required String vendorProductId,
    required double sellingPrice,
    required int stock,
    required bool isAvailable,
  }) async {
    await _vendorProductService.updateVendorProduct(
      vendorProductId: vendorProductId,
      sellingPrice: sellingPrice,
      stock: stock,
      isAvailable: isAvailable,
    );

    await loadProducts();
  }
}
