class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String? youtubeUrl;
  final Map<String, String> ingredients;
  final String? category;


  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
    this.youtubeUrl,
    this.category,
  });


  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <String, String>{};

    for (var i = 1; i <= 20; i++) {
      final ingr = (json['strIngredient$i'] ?? '') as String;
      final measure = (json['strMeasure$i'] ?? '') as String;

      if (ingr.trim().isNotEmpty) {
        ingredients[ingr.trim()] = measure.trim();
      }
    }

    return MealDetail(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      thumbnail: json['strMealThumb'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
      category: json['strCategory'] as String?,
    );
  }
}