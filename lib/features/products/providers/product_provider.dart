import 'package:flutter/material.dart';
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

  // ==========================================
  // LOAD PRODUCTS PAGE
  // ==========================================

  Future<void> loadProducts() async {
    try {
      debugPrint('================================');
      debugPrint('PRODUCT PAGE LOAD START');

      state = state.copyWith(isLoading: true, clearError: true);

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('Vendor is not logged in');
      }

      final vendorId = user.id;

      debugPrint('PRODUCT PAGE VENDOR ID: $vendorId');

      // ==========================================
      // 1. LOAD CATEGORIES
      // ==========================================

      final categories = await _categoryService.getCategories();

      debugPrint('PRODUCT PAGE CATEGORIES COUNT: ${categories.length}');

      debugPrint(
        'PRODUCT PAGE CATEGORIES: '
        '${categories.map((e) => e.name).toList()}',
      );

      // Categories ko state me immediately save karo
      state = state.copyWith(categories: categories);

      debugPrint(
        'PRODUCT STATE CATEGORIES COUNT: '
        '${state.categories.length}',
      );

      // ==========================================
      // 2. LOAD VENDOR PRODUCTS
      // ==========================================

      await _loadVendorProducts(
        vendorId: vendorId,
        categoryId: state.selectedCategory?.id,
        searchQuery: state.searchQuery,
      );

      debugPrint('PRODUCT PAGE LOAD END');
      debugPrint('================================');
    } catch (e, stackTrace) {
      debugPrint('PRODUCT PAGE ERROR: $e');
      debugPrint('$stackTrace');

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ==========================================
  // LOAD VENDOR PRODUCTS
  // ==========================================

  Future<void> _loadVendorProducts({
    required String vendorId,
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      debugPrint('================================');
      debugPrint('LOADING VENDOR PRODUCTS');
      debugPrint('Vendor ID: $vendorId');
      debugPrint('Category ID: $categoryId');
      debugPrint('Search: $searchQuery');

      final products = await _vendorProductService.getVendorProductsWithDetails(
        vendorId,
        categoryId: categoryId,
        searchQuery: searchQuery,
      );

      debugPrint('PRODUCT PAGE PRODUCTS COUNT: ${products.length}');

      for (final product in products) {
        debugPrint(
          'VENDOR PRODUCT: '
          '${product.product.name} | '
          'ID: ${product.vendorProduct.id}',
        );
      }

      state = state.copyWith(isLoading: false, products: products);

      debugPrint(
        'PRODUCT FINAL CATEGORIES COUNT: '
        '${state.categories.length}',
      );

      debugPrint(
        'PRODUCT FINAL PRODUCTS COUNT: '
        '${state.products.length}',
      );

      debugPrint('================================');
    } catch (e, stackTrace) {
      debugPrint('VENDOR PRODUCTS ERROR: $e');
      debugPrint('$stackTrace');

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ==========================================
  // REFRESH
  // ==========================================

  Future<void> refresh() async {
    await loadProducts();
  }

  // ==========================================
  // SELECT CATEGORY
  // ==========================================

  Future<void> selectCategory(CategoryModel category) async {
    debugPrint(
      'PRODUCT PAGE CATEGORY SELECTED: '
      '${category.name} (${category.id})',
    );

    state = state.copyWith(
      selectedCategory: category,
      isLoading: true,
      clearError: true,
    );

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Vendor is not logged in',
      );
      return;
    }

    await _loadVendorProducts(
      vendorId: user.id,
      categoryId: category.id,
      searchQuery: state.searchQuery,
    );
  }

  // ==========================================
  // CLEAR CATEGORY
  // ==========================================

  Future<void> clearCategory() async {
    debugPrint('PRODUCT PAGE CATEGORY: ALL');

    state = state.copyWith(
      clearCategory: true,
      isLoading: true,
      clearError: true,
    );

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Vendor is not logged in',
      );
      return;
    }

    await _loadVendorProducts(
      vendorId: user.id,
      categoryId: null,
      searchQuery: state.searchQuery,
    );
  }

  // ==========================================
  // SEARCH
  // ==========================================

  Future<void> searchProducts(String query) async {
    debugPrint('PRODUCT PAGE SEARCH: $query');

    state = state.copyWith(
      searchQuery: query,
      isLoading: true,
      clearError: true,
    );

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Vendor is not logged in',
      );
      return;
    }

    await _loadVendorProducts(
      vendorId: user.id,
      categoryId: state.selectedCategory?.id,
      searchQuery: query,
    );
  }

  // ==========================================
  // DELETE PRODUCT
  // ==========================================

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

  // ==========================================
  // UPDATE PRODUCT
  // ==========================================

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

  // ==========================================
  // RESET
  // ==========================================

  void reset() {
    state = const ProductsState();
  }

  // ==========================================
  // GETTERS
  // ==========================================

  bool get hasProducts => state.products.isNotEmpty;

  bool get hasCategory => state.selectedCategory != null;

  bool get isSearching => state.searchQuery.trim().isNotEmpty;

  int get totalProducts => state.products.length;
}
