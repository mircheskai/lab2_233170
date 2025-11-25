import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'screens/meals_by_category_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'models/meal_detail.dart';


void main() {
  runApp(const MealDbApp());
}


class MealDbApp extends StatelessWidget {
  const MealDbApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),

      routes: {
        '/': (context) => const CategoriesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == MealsByCategoryScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => MealsByCategoryScreen(category: args['category']),
          );
        }


        if (settings.name == MealDetailScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => MealDetailScreen(
              mealId: args['id'] as String?,
              mealDetail: args['mealDetail'] as MealDetail?,
            ),
          );
        }


        return null;
      },
    );
  }
}