class MealSummary {
  final String id;
  final String name;
  final String thumb;
  final String? category;


  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
    this.category,
  });


  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      thumb: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String?,
    );
  }
}