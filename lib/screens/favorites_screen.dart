import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';


class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favService = FavoritesService.instance;

  @override
  void initState() {
    super.initState();
    _favService.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: StreamBuilder<List<MealSummary>>(
        stream: _favService.favoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) return const Center(child: Text('No favorites yet'));
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) => MealCard(
              meal: list[i],
              onTap: () => Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: {'id': list[i].id}),
            ),
          );
        },
      ),
    );
  }
}