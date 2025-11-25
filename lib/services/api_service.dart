import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';


class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';


  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final categories = data['categories'] as List<dynamic>? ?? [];

      return categories.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load categories');
  }


  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final encoded = Uri.encodeComponent(category);
    final url = Uri.parse('$_base/filter.php?c=$encoded');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final meals = data['meals'] as List<dynamic>? ?? [];

      return meals.map((e) => MealSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load meals for category');
  }


  static Future<List<MealSummary>> searchMeals(String query) async {
    if (query.trim().isEmpty) return [];

    final encoded = Uri.encodeComponent(query);
    final url = Uri.parse('$_base/search.php?s=$encoded');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final meals = data['meals'] as List<dynamic>? ?? [];

      return meals.map((e) => MealSummary.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Search failed');
  }


  static Future<MealDetail> lookupMeal(String id) async {
    final url = Uri.parse('$_base/lookup.php?i=$id');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final meals = data['meals'] as List<dynamic>? ?? [];
      if (meals.isEmpty) throw Exception('Meal not found');

      return MealDetail.fromJson(meals.first as Map<String, dynamic>);
    }
    throw Exception('Failed to lookup meal');
  }


  static Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final meals = data['meals'] as List<dynamic>? ?? [];
      if (meals.isEmpty) throw Exception('No random meal');

      return MealDetail.fromJson(meals.first as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch random meal');
  }
}