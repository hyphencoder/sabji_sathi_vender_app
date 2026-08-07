import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/auth/services/auth_service.dart';
import '../../../services/storage_service.dart';
import '../models/vendor_bank_model.dart';
import '../models/vendor_model.dart';
import 'bank_service.dart';

class ShopService {
  ShopService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static const String _table = 'vendors';

  // ==========================================================
  // Create Vendor
  // ==========================================================

  static Future<void> createShop(VendorModel vendor) async {
    await _client.from(_table).insert(vendor.toMap());
  }

  // ==========================================================
  // Get Vendor
  // ==========================================================

  static Future<VendorModel?> getShop() async {
    final user = AuthService.currentUser;

    if (user == null) return null;

    final data = await _client
        .from(_table)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;

    return VendorModel.fromMap(data);
  }

  // ==========================================================
  // Update Vendor
  // ==========================================================

  static Future<void> updateShop(Map<String, dynamic> data) async {
    final user = AuthService.currentUser;

    if (user == null) return;

    await _client.from(_table).update(data).eq('id', user.id);
  }

  // ==========================================================
  // Complete Setup
  // ==========================================================

  static Future<void> completeSetup() async {
    final user = AuthService.currentUser;

    if (user == null) return;

    await _client
        .from(_table)
        .update({
          'shop_completed': true,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);
  }

  // ==========================================================
  // Rollback Vendor
  // ==========================================================

  static Future<void> rollbackVendor() async {
    final user = AuthService.currentUser;

    if (user == null) return;

    await _client.from(_table).delete().eq('id', user.id);
  }

  // ==========================================================
  // Has Shop
  // ==========================================================

  static Future<bool> hasShop() async {
    final user = AuthService.currentUser;

    if (user == null) return false;

    final data = await _client
        .from(_table)
        .select('shop_completed')
        .eq('id', user.id)
        .maybeSingle();

    return data?['shop_completed'] == true;
  }

  // ==========================================================
  // Create Complete Shop
  // ==========================================================

  static Future<void> createCompleteShop({
    required VendorModel vendor,
    required VendorBankModel bank,
    File? profileImage,
    File? shopImage,
  }) async {
    final user = AuthService.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }
    print("========== CREATE COMPLETE SHOP ==========");
    print("1. User : ${user.id}");

    String? profileImageUrl;
    String? shopImageUrl;

    try {
      // =====================================
      // Upload Profile Image
      // =====================================

      if (profileImage != null) {
        print("2. Uploading profile image...");
        profileImageUrl = await StorageService.uploadProfileImage(
          vendorId: user.id,
          image: profileImage,
        );
        print("Profile Uploaded");
      }

      // =====================================
      // Upload Shop Image
      // =====================================

      if (shopImage != null) {
        print("3. Uploading shop image...");
        shopImageUrl = await StorageService.uploadShopImage(
          vendorId: user.id,
          image: shopImage,
        );
        print("✅ Shop uploaded");
      }

      // =====================================
      // Create Vendor
      // =====================================

      final newVendor = vendor.copyWith(
        profileImage: profileImageUrl,
        shopImage: shopImageUrl,
      );

      print("4. Creating vendor...");
      await createShop(newVendor);
      print("✅ Vendor created");

      // =====================================
      // Create Bank
      // =====================================

      print("5. Creating bank...");
      await BankService.createBank(bank);
      print("✅ Bank created");

      // =====================================
      // Complete Setup
      // =====================================

      print("6. Completing setup...");
      await completeSetup();
      print("✅ Setup completed");
    } catch (e, stackTrace) {
      print("========== ERROR OCCURRED ==========");
      print("Error occurred: $e");
      print("Stack trace: $stackTrace");
      // =====================================
      // Rollback Vendor
      // =====================================

      try {
        await rollbackVendor();
      } catch (_) {}

      // =====================================
      // Delete Images
      // =====================================

      try {
        if (profileImage != null) {
          final ext = profileImage.path.split('.').last;

          await StorageService.deleteProfileImage(
            vendorId: user.id,
            extension: ext,
          );
        }
      } catch (_) {}

      try {
        if (shopImage != null) {
          final ext = shopImage.path.split('.').last;

          await StorageService.deleteShopImage(
            vendorId: user.id,
            extension: ext,
          );
        }
      } catch (_) {}

      rethrow;
    }
  }

  /// Get Vendor Status
  static Future<String?> getVendorStatus() async {
    final user = AuthService.currentUser;

    if (user == null) return null;

    final data = await _client
        .from(_table)
        .select('status')
        .eq('id', user.id)
        .maybeSingle();

    return data?['status'];
  }
}
