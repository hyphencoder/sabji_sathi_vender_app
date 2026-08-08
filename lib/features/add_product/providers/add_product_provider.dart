import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/shared/models/category_model.dart';
import 'package:vender_app/shared/models/product_model.dart';

import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/vendor_product_service.dart';

final addProductProvider =
    StateNotifierProvider<AddProductNotifier, AddProductState>(
      (ref) => AddProductNotifier(),
    );

class AddProductState {
  const AddProductState({
    this.isLoading = false,
    this.categories = const [],
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory,
    this.searchQuery = '',
  });

  final bool isLoading;
  final List<CategoryModel> categories;
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final CategoryModel? selectedCategory;
  final String searchQuery;

  AddProductState copyWith({
    bool? isLoading,
    List<CategoryModel>? categories,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    CategoryModel? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AddProductNotifier extends StateNotifier<AddProductState> {
  AddProductNotifier() : super(const AddProductState());

  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  final VendorProductService _vendorProductService = VendorProductService();

  /// Load Categories & Products
  /// Load Categories & Products
  Future<void> loadData() async {
    try {
      state = state.copyWith(isLoading: true);

      final vendorId = Supabase.instance.client.auth.currentUser!.id;

      final categories = await _categoryService.getCategories();
      final products = await _productService.getProducts();

      final vendorProducts = await _vendorProductService.getVendorProducts(
        vendorId,
      );

      final addedProductIds = vendorProducts.map((e) => e.productId).toSet();

      final availableProducts = products
          .where((e) => !addedProductIds.contains(e.id))
          .toList();

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        allProducts: availableProducts,
        filteredProducts: availableProducts,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Search Products
  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Select Category
  void selectCategory(CategoryModel? category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  /// Clear Filters
  void clearFilters() {
    state = state.copyWith(
      clearCategory: true,
      searchQuery: '',
      filteredProducts: state.allProducts,
    );
  }

  /// Apply Filters
  void _applyFilters() {
    List<ProductModel> products = List.from(state.allProducts);

    if (state.selectedCategory != null) {
      products = products
          .where((e) => e.categoryId == state.selectedCategory!.id)
          .toList();
    }

    if (state.searchQuery.trim().isNotEmpty) {
      final query = state.searchQuery.toLowerCase();

      products = products
          .where((e) => e.name.toLowerCase().contains(query))
          .toList();
    }

    state = state.copyWith(filteredProducts: products);
  }

  /// Save Vendor Product
  /// Save Vendor Product
  Future<void> saveVendorProduct({
    required String vendorId,
    required String productId,
    required double sellingPrice,
    required int stock,
    bool isAvailable = true,
  }) async {
    try {
      final model = VendorProductModel(
        vendorId: vendorId,
        productId: productId,
        sellingPrice: sellingPrice,
        stock: stock,
        isAvailable: isAvailable,
      );

      await _vendorProductService.saveVendorProduct(model);

      // Refresh list so added product disappears
      await loadData();
    } catch (e) {
      rethrow;
    }
  }
}
