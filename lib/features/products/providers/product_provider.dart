import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/services/category_service.dart';
import 'package:vender_app/features/add_product/services/vendor_product_service.dart';
import 'package:vender_app/shared/models/category_model.dart';
import 'package:vender_app/shared/models/vendor_product_details_model.dart';

import 'products_state.dart';

final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);

class ProductsNotifier extends Notifier<ProductsState> {
  final VendorProductService _vendorProductService = VendorProductService();

  final CategoryService _categoryService = CategoryService();

  @override
  ProductsState build() {
    return const ProductsState();
  }

  //==========================================
  // Load Products
  //==========================================

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final vendorId = Supabase.instance.client.auth.currentUser!.id;

      final categories = await _categoryService.getCategories();

      final products = await _vendorProductService.getVendorProductsWithDetails(
        vendorId,
        categoryId: state.selectedCategory?.id,
        searchQuery: state.searchQuery,
      );

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //==========================================
  // Refresh
  //==========================================

  Future<void> refresh() async {
    await loadProducts();
  }

  //==========================================
  // Select Category
  //==========================================

  Future<void> selectCategory(CategoryModel? category) async {
    state = state.copyWith(selectedCategory: category);

    await loadProducts();
  }

  //==========================================
  // Clear Category
  //==========================================

  Future<void> clearCategory() async {
    state = state.copyWith(clearCategory: true);

    await loadProducts();
  }

  //==========================================
  // Search Products
  //==========================================

  Future<void> searchProducts(String query) async {
    state = state.copyWith(searchQuery: query);

    await loadProducts();
  }

  //==========================================
  // Delete Product
  //==========================================

  Future<void> deleteProduct(String vendorProductId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _vendorProductService.deleteVendorProduct(vendorProductId);

      await loadProducts();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  //==========================================
  // Update Product
  //==========================================

  Future<void> updateProduct(VendorProductDetailsModel product) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _vendorProductService.updateVendorProduct(product.vendorProduct);

      await loadProducts();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  //==========================================
  // Reset Provider
  //==========================================

  void reset() {
    state = const ProductsState();
  }

  //==========================================
  // Helper Getters
  //==========================================

  bool get hasProducts => state.products.isNotEmpty;

  bool get hasCategory => state.selectedCategory != null;

  bool get isSearching => state.searchQuery.trim().isNotEmpty;

  int get totalProducts => state.products.length;
}
