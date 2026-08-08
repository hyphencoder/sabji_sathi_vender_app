import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';

class CategoryService {
  CategoryService();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('priority', ascending: true);

      return response
          .map<CategoryModel>((e) => CategoryModel.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return CategoryModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}
