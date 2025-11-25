import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'meal_detail_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}


class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  List<Category> _filtered = [];
  bool _loading = true;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
        _filtered = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading categories: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String q) {
    q = q.toLowerCase();
    setState(() {
      _filtered = _categories.where((c) => c.name.toLowerCase().contains(q) || c.description.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _openRandom() async {
    try {
      final meal = await ApiService.fetchRandomMeal();
      Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: {'mealDetail': meal});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching random meal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          actions: [
            IconButton(onPressed: _openRandom, icon: const Icon(Icons.casino), tooltip: 'Random Recipe')
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearch,
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,          // ← 1 card per row
                  childAspectRatio: 3,        // ← adjust height/width of the card
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final cat = _filtered[i];
                  return CategoryCard(
                    category: cat,
                    onTap: () {
                      Navigator.pushNamed(context, '/mealsByCategory', arguments: {'category': cat.name});
                    },
                  );
                },
              ),
            )
          ],
        )
    );
  }
}














