import 'package:receitas/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    return await _supabaseClient
    .from('recipes')
    .select()
    .order('id', ascending: true);
  }

  Future<Map<String, dynamic>?> fetchRecipeById(String id) async {
    return await _supabaseClient
        .from('recipes')
        .select()
        .eq('id', id)
        .single();
  }

  Future<List<Map<String, dynamic>>> fetchFavRecipes(String userId) async {
    return await _supabaseClient
        .from('favorites')
        .select('recipes(*)')
        .eq('user_id', userId);
  }
}