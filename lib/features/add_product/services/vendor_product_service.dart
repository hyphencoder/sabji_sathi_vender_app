import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/models/vender_product_model.dart';
import 'package:vender_app/shared/models/product_model.dart';
import 'package:vender_app/shared/models/vendor_product_details_model.dart';

class VendorProductService {
  VendorProductService();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Save (Insert / Update)
  Future<VendorProductModel> saveVendorProduct(
    VendorProductModel product,
  ) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .upsert(product.toJson(), onConflict: 'vendor_id,product_id')
          .select()
          .single();

      return VendorProductModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to save vendor product: $e');
    }
  }

  /// Get Vendor Products
  Future<List<VendorProductModel>> getVendorProducts(String vendorId) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .select()
          .eq('vendor_id', vendorId)
          .order('updated_at', ascending: false);

      return response
          .map<VendorProductModel>((e) => VendorProductModel.fromMap(e))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to load vendor products: $e');
    }
  }

  /// Get Single Vendor Product
  Future<VendorProductModel?> getVendorProduct(
    String vendorId,
    String productId,
  ) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .select()
          .eq('vendor_id', vendorId)
          .eq('product_id', productId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return VendorProductModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to load vendor product: $e');
    }
  }

  /// Delete Vendor Product
  Future<void> deleteVendorProduct(String vendorProductId) async {
    try {
      await _supabase
          .from('vendor_products')
          .delete()
          .eq('id', vendorProductId);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete vendor product: $e');
    }
  }

  /// Get Vendor Products With Product Details
  /// Get Vendor Products With Product Details
  ///
  /// Product Page ke liye:
  /// vendor_products
  ///      ↓
  /// current vendor ke products
  ///      ↓
  /// products table se details
  ///      ↓
  /// optional category filter
  ///      ↓
  /// optional search
  Future<List<VendorProductDetailsModel>> getVendorProductsWithDetails(
    String vendorId, {
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      debugPrint('==========================================');
      debugPrint('PRODUCT PAGE SERVICE');
      debugPrint('Vendor ID: $vendorId');
      debugPrint('Category ID: $categoryId');
      debugPrint('Search: $searchQuery');
      debugPrint('==========================================');

      var query = _supabase
          .from('vendor_products')
          .select('''
          *,
          products!fk_vendor_products_product!inner(
            *,
            categories(name)
          )
        ''')
          .eq('vendor_id', vendorId);

      // ==========================================
      // CATEGORY FILTER
      // ==========================================

      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('products.category_id', categoryId);
      }

      // ==========================================
      // SEARCH FILTER
      // ==========================================

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('products.name', '%${searchQuery.trim()}%');
      }

      // ==========================================
      // FETCH
      // ==========================================

      final response = await query.order('updated_at', ascending: false);

      debugPrint('==========================================');
      debugPrint('PRODUCT PAGE RAW RESPONSE');
      debugPrint('RAW COUNT: ${response.length}');

      debugPrint('==========================================');

      // ==========================================
      // MAP
      // ==========================================

      final products = response.map<VendorProductDetailsModel>((e) {
        final data = Map<String, dynamic>.from(e);

        final productData = Map<String, dynamic>.from(data['products'] as Map);

        final vendorProduct = VendorProductModel.fromMap(data);

        final product = ProductModel.fromMap(productData);

        debugPrint(
          'VENDOR PRODUCT: '
          '${product.name} | '
          'VendorProduct ID: ${vendorProduct.id} | '
          'Product ID: ${product.id}',
        );

        return VendorProductDetailsModel(
          vendorProduct: vendorProduct,
          product: product,
        );
      }).toList();

      debugPrint('PRODUCT PAGE MAPPED COUNT: ${products.length}');

      return products;
    } on PostgrestException catch (e) {
      debugPrint('==========================================');
      debugPrint('PRODUCT PAGE POSTGREST ERROR');
      debugPrint('Message: ${e.message}');
      debugPrint('Details: ${e.details}');
      debugPrint('Hint: ${e.hint}');
      debugPrint('Code: ${e.code}');
      debugPrint('==========================================');

      throw Exception(e.message);
    } catch (e, stackTrace) {
      debugPrint('==========================================');
      debugPrint('PRODUCT PAGE SERVICE ERROR');
      print(e);
      print(stackTrace);
      debugPrint('==========================================');

      throw Exception('Failed to load vendor products with details: $e');
    }
  }

  /// Update Vendor Product
  Future<VendorProductModel> updateVendorProduct(
    VendorProductModel product,
  ) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .update(product.toVendorUpdateJson())
          .eq('id', product.id!)
          .select()
          .single();

      return VendorProductModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update vendor product: $e');
    }
  }
}
