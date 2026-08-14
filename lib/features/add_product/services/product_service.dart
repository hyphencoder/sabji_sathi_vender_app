import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/shared/models/product_model.dart';

class ProductService {
  ProductService();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all active products
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            categories(name)
          ''')
          .eq('is_active', true)
          .order('priority', ascending: true);

      return response
          .map<ProductModel>((e) => ProductModel.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// Gets master products that have not yet been added by this vendor.
  /// Category and search filtering stay in Supabase. The vendor's small set
  /// of linked product IDs is safely excluded after the master query.
  Future<List<ProductModel>> getAvailableProducts({
    required String vendorId,
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      print("========== Product Service ==========");
      print("Vendor ID: $vendorId");
      print("Category ID: $categoryId");
      print("Search: $searchQuery");

      final vendorProducts = await _supabase
          .from('vendor_products')
          .select('product_id')
          .eq('vendor_id', vendorId);

      print("Vendor Products: $vendorProducts");

      final addedProductIds = vendorProducts
          .map((item) => item['product_id'] as String)
          .toList();

      var query = _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('is_active', true);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('name', '%${searchQuery.trim()}%');
      }

      final response = await query.order('priority', ascending: true);

      print("RAW RESPONSE:");
      print(response);

      final products = response
          .map<ProductModel>((e) => ProductModel.fromMap(e))
          .toList();

      print("Mapped Products Count: ${products.length}");

      for (final p in products) {
        print("${p.name} - ${p.id}");
      }

      final availableProducts = products
          .where((p) => !addedProductIds.contains(p.id))
          .toList();

      print("Available Products Count: ${availableProducts.length}");

      return availableProducts;
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }

  /// Get products of selected category
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            categories(name)
          ''')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('priority', ascending: true);

      return response
          .map<ProductModel>((e) => ProductModel.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }

  /// Get single product
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select('''
            *,
            categories(name)
          ''')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return ProductModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
