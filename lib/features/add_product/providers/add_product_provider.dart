import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/features/add_product/providers/add_product_state.dart';
import 'package:vender_app/features/add_product/services/category_service.dart';
import 'package:vender_app/features/add_product/services/product_service.dart';
import 'package:vender_app/features/add_product/services/vendor_product_service.dart';
import 'package:vender_app/shared/models/category_model.dart';

final addProductProvider =
    NotifierProvider<AddProductNotifier, AddProductState>(
      AddProductNotifier.new,
    );

class AddProductNotifier extends Notifier<AddProductState> {
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  final VendorProductService _vendorProductService = VendorProductService();

  @override
  AddProductState build() {
    return const AddProductState();
  }

  //============================
  // Load Data (Initial) - FIXED
  //============================

  Future<void> loadData() async {
    try {
      debugPrint("🔄 Loading data...");
      state = state.copyWith(isLoading: true);

      // ✅ Load categories
      final categories = await _categoryService.getCategories();
      debugPrint("✅ Categories loaded: ${categories.length}");

      // ✅ Load vendor products
      final vendorId = Supabase.instance.client.auth.currentUser!.id;
      final vendorProducts = await _vendorProductService.getVendorProducts(
        vendorId,
      );
      debugPrint("✅ Vendor products loaded: ${vendorProducts.length}");

      // ✅ Set selectedCategory = null (All Categories)
      state = state.copyWith(
        isLoading: false,
        categories: categories,
        vendorProducts: vendorProducts,
        clearCategory: true, // ✅ Default "All"
        allProducts: const [],
        filteredProducts: const [],
        searchQuery: '',
      );

      // ✅ IMPORTANT: Load all products for "All Categories"
      await _loadAllProducts();
      debugPrint("✅ All products loaded for 'All Categories'");
    } catch (e) {
      debugPrint("❌ Error loading data: $e");
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  //============================
  // Load All Products - FIXED
  //============================

  Future<void> _loadAllProducts() async {
    final vendorId = Supabase.instance.client.auth.currentUser!.id;

    debugPrint("🔄 Loading all products...");
    state = state.copyWith(isLoading: true);

    try {
      final products = await _productService.getAvailableProducts(
        vendorId: vendorId,
        categoryId: null, // ✅ No category filter
        searchQuery: state.searchQuery,
      );

      debugPrint("✅ Loaded all products: ${products.length}");

      state = state.copyWith(
        isLoading: false,
        allProducts: products,
        filteredProducts: products,
      );
    } catch (e) {
      debugPrint("❌ Error loading all products: $e");
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  //============================
  // Select Category - FIXED
  //============================

  Future<void> selectCategory(CategoryModel? category) async {
    debugPrint("🔄 Selecting category: ${category?.name ?? 'All'}");
    if (category == null) {
      state = state.copyWith(clearCategory: true, searchQuery: '');

      debugPrint("📂 Loading all products for 'All Categories'");
      await _loadAllProducts();
    } else {
      state = state.copyWith(selectedCategory: category, searchQuery: '');

      debugPrint("📂 Loading products for category: ${category.name}");
      await _reloadProducts();
    }
  }

  //============================
  // Reload Products (Category Specific)
  //============================

  Future<void> _reloadProducts() async {
    final vendorId = Supabase.instance.client.auth.currentUser!.id;

    debugPrint("🔄 Reloading products for category...");
    state = state.copyWith(isLoading: true);

    try {
      final products = await _productService.getAvailableProducts(
        vendorId: vendorId,
        categoryId: state.selectedCategory?.id,
        searchQuery: state.searchQuery,
      );

      debugPrint("✅ Loaded products for category: ${products.length}");

      state = state.copyWith(
        isLoading: false,
        allProducts: products,
        filteredProducts: products,
      );
    } catch (e) {
      debugPrint("❌ Error loading products: $e");
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  //============================
  // Search Products - FIXED
  //============================

  Future<void> searchProducts(String query) async {
    debugPrint("🔍 Searching: '$query'");
    state = state.copyWith(searchQuery: query);

    if (state.selectedCategory == null) {
      // ✅ Search in all products
      await _loadAllProducts();
    } else {
      // ✅ Search in category
      await _reloadProducts();
    }
  }

  //============================
  // Save Vendor Product
  //============================

  Future<void> saveVendorProduct({
    required String vendorId,
    required String productId,
    required double sellingPrice,
    required double mrp,
    required double discountPrice,
    required int stock,
    required int minOrderQty,
    required int maxOrderQty,
    required String sku,
    bool isAvailable = true,
  }) async {
    try {
      debugPrint("🔄 Saving vendor product: $productId");
      state = state.copyWith(isLoading: true);

      final model = VendorProductModel(
        vendorId: vendorId,
        productId: productId,
        sellingPrice: sellingPrice,
        mrp: mrp,
        discountPrice: discountPrice,
        stock: stock,
        minOrderQty: minOrderQty,
        maxOrderQty: maxOrderQty,
        sku: sku,
        status: 'pending',
        isAvailable: isAvailable,
        isFeatured: false,
      );

      await _vendorProductService.saveVendorProduct(model);
      debugPrint("✅ Vendor product saved");

      // ✅ Reload vendor products
      await _loadVendorProducts();

      // ✅ Reload products based on current selection
      if (state.selectedCategory == null) {
        await _loadAllProducts();
      } else {
        await _reloadProducts();
      }

      state = state.copyWith(isLoading: false);
      debugPrint("✅ Products refreshed after save");
    } catch (e) {
      debugPrint("❌ Error saving product: $e");
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  //============================
  // Load Vendor Products
  //============================

  Future<void> _loadVendorProducts() async {
    try {
      final vendorId = Supabase.instance.client.auth.currentUser!.id;
      final vendorProducts = await _vendorProductService.getVendorProducts(
        vendorId,
      );
      state = state.copyWith(vendorProducts: vendorProducts);
      debugPrint("✅ Vendor products loaded: ${vendorProducts.length}");
    } catch (e) {
      debugPrint("❌ Error loading vendor products: $e");
    }
  }

  //============================
  // Refresh - FIXED
  //============================

  Future<void> refresh() async {
    debugPrint("🔄 Refreshing products...");
    if (state.selectedCategory == null) {
      await _loadAllProducts();
    } else {
      await _reloadProducts();
    }
  }

  //============================
  // Reset
  //============================

  void reset() {
    debugPrint("🔄 Resetting state");
    state = const AddProductState();
  }

  //============================
  // Getters
  //============================

  bool get hasCategory => state.selectedCategory != null;
  bool get hasProducts => state.filteredProducts.isNotEmpty;
  bool get isSearching => state.searchQuery.trim().isNotEmpty;
  int get totalProducts => state.filteredProducts.length;
}
