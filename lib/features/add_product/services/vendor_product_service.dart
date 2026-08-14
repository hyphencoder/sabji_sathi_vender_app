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
  Future<List<VendorProductDetailsModel>> getVendorProductsWithDetails(
    String vendorId, {
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      var query = _supabase
          .from('vendor_products')
          .select('''
            *,
            products!vendor_products_product_id_fkey!inner(
              *,
              categories(name)
            )
          ''')
          .eq('vendor_id', vendorId);

      if (categoryId != null) {
        query = query.eq('products.category_id', categoryId);
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('products.name', '%${searchQuery.trim()}%');
      }

      final response = await query.order('updated_at', ascending: false);

      return response.map<VendorProductDetailsModel>((e) {
        return VendorProductDetailsModel(
          vendorProduct: VendorProductModel.fromMap(e),
          product: ProductModel.fromMap(e['products']),
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
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
