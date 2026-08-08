import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';

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
