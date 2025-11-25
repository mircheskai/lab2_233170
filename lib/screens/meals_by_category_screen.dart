import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';


class MealsByCategoryScreen extends StatefulWidget {
  static const routeName = '/mealsByCategory';
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}


class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  List<MealSummary> _meals = [];
  List<MealSummary> _filtered = [];
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
      final meals = await ApiService.fetchMealsByCategory(widget.category);
      setState(() {
        _meals = meals;
        _filtered = meals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading meals: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _onSearch(String q) async {
    q = q.trim();
    if (q.isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }

    setState(() => _loading = true);

    try {
      final results = await ApiService.searchMeals(q);
      final filtered = results.where((m) => (m.category ?? widget.category) == widget.category).toList();
      setState(() {
        _filtered = filtered;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search meals in this category...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onSearch,
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final meal = _filtered[i];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: {'id': meal.id});
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}