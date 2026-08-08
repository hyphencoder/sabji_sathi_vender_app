import 'package:supabase_flutter/supabase_flutter.dart';

class StorageHelper {
  StorageHelper._();

  static String getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    return Supabase.instance.client.storage
        .from('product-images')
        .getPublicUrl(imagePath);
  }
}
