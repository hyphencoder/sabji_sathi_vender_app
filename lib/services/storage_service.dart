import 'dart:io';

import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  StorageService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static const String _profileBucket = 'vendor-profile-images';
  static const String _shopBucket = 'vendor-shop-images';

  // ==========================================
  // Upload Vendor Profile Image
  // ==========================================

  static Future<String> uploadProfileImage({
    required String vendorId,
    required File image,
  }) async {
    final extension = image.path.split('.').last;

    final path = '$vendorId/profile.$extension';
    print("========== UPLOAD PROFILE IMAGE ==========");
    print("Current User : ${_client.auth.currentUser?.id}");
    print("Current Session : ${_client.auth.currentSession != null}");
    print("Bucket : $_profileBucket");
    print("Path : $path");
    await _client.storage
        .from(_profileBucket)
        .upload(
          path,
          image,
          fileOptions: FileOptions(
            upsert: false,
            contentType: lookupMimeType(image.path) ?? 'image/jpeg',
          ),
        );

    return _client.storage.from(_profileBucket).getPublicUrl(path);
  }

  // ==========================================
  // Upload Shop Image
  // ==========================================

  static Future<String> uploadShopImage({
    required String vendorId,
    required File image,
  }) async {
    final extension = image.path.split('.').last;

    final path = '$vendorId/shop.$extension';

    await _client.storage
        .from(_shopBucket)
        .upload(
          path,
          image,
          fileOptions: FileOptions(
            upsert: false,
            contentType: lookupMimeType(image.path) ?? 'image/jpeg',
          ),
        );

    return _client.storage.from(_shopBucket).getPublicUrl(path);
  }

  // ==========================================
  // Delete Vendor Profile Image
  // ==========================================

  static Future<void> deleteProfileImage({
    required String vendorId,
    required String extension,
  }) async {
    await _client.storage.from(_profileBucket).remove([
      '$vendorId/profile.$extension',
    ]);
  }

  // ==========================================
  // Delete Shop Image
  // ==========================================

  static Future<void> deleteShopImage({
    required String vendorId,
    required String extension,
  }) async {
    await _client.storage.from(_shopBucket).remove([
      '$vendorId/shop.$extension',
    ]);
  }

  // ==========================================
  // Get Public URL
  // ==========================================

  static String getProfileImageUrl({
    required String vendorId,
    required String extension,
  }) {
    return _client.storage
        .from(_profileBucket)
        .getPublicUrl('$vendorId/profile.$extension');
  }

  static String getShopImageUrl({
    required String vendorId,
    required String extension,
  }) {
    return _client.storage
        .from(_shopBucket)
        .getPublicUrl('$vendorId/shop.$extension');
  }
}
