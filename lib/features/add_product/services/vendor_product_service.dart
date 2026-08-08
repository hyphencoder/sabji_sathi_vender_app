import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vender_app/features/add_product/models/vender_product_model.dart';

class VendorProductService {
  VendorProductService();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Add or Update Vendor Product
  Future<VendorProductModel> saveVendorProduct(
    VendorProductModel product,
  ) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .upsert(product.toMap(), onConflict: 'vendor_id,product_id')
          .select()
          .single();

      return VendorProductModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to save vendor product: $e');
    }
  }

  /// Get All Products of Vendor
  Future<List<VendorProductModel>> getVendorProducts(String vendorId) async {
    try {
      final response = await _supabase
          .from('vendor_products')
          .select()
          .eq('vendor_id', vendorId);

      return response
          .map<VendorProductModel>((e) => VendorProductModel.fromMap(e))
          .toList();
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
    } catch (e) {
      throw Exception('Failed to load vendor product: $e');
    }
  }

  /// Update Stock
  Future<void> updateStock({
    required String vendorProductId,
    required int stock,
  }) async {
    try {
      await _supabase
          .from('vendor_products')
          .update({
            'stock': stock,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorProductId);
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  /// Update Selling Price
  Future<void> updatePrice({
    required String vendorProductId,
    required double sellingPrice,
  }) async {
    try {
      await _supabase
          .from('vendor_products')
          .update({
            'selling_price': sellingPrice,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorProductId);
    } catch (e) {
      throw Exception('Failed to update price: $e');
    }
  }

  /// Update Availability
  Future<void> updateAvailability({
    required String vendorProductId,
    required bool isAvailable,
  }) async {
    try {
      await _supabase
          .from('vendor_products')
          .update({
            'is_available': isAvailable,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorProductId);
    } catch (e) {
      throw Exception('Failed to update availability: $e');
    }
  }

  /// Delete Vendor Product
  Future<void> deleteVendorProduct(String vendorProductId) async {
    try {
      await _supabase
          .from('vendor_products')
          .delete()
          .eq('id', vendorProductId);
    } catch (e) {
      throw Exception('Failed to delete vendor product: $e');
    }
  }
}
