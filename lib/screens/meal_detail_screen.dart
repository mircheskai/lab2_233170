import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';


class MealDetailScreen extends StatefulWidget {
  static const routeName = '/mealDetail';
  final String? mealId;
  final MealDetail? mealDetail;

  const MealDetailScreen({super.key, this.mealId, this.mealDetail});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}


class _MealDetailScreenState extends State<MealDetailScreen> {
  MealDetail? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.mealDetail != null) {
      setState(() {
        _meal = widget.mealDetail;
        _loading = false;
      });
      return;
    }

    if (widget.mealId == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final meal = await ApiService.lookupMeal(widget.mealId!);
      setState(() => _meal = meal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading meal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openYoutube() async {
    final url = _meal?.youtubeUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open YouTube link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_meal?.name ?? 'Recipe'),
      ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _meal == null
            ? const Center(child: Text('No meal data'))
            : SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: _meal!.thumbnail,
                      height: 220,
                      fit: BoxFit.cover,
                      placeholder: (c, _) => const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
                      errorWidget: (c, _, __) => const SizedBox(height: 220, child: Center(child: Icon(Icons.error))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _meal!.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (_meal!.category != null) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Chip(label: Text(_meal!.category!)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(_meal!.instructions),
                  const SizedBox(height: 12),
                  const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  ..._meal!.ingredients.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text('- ${e.key} — ${e.value}'),
                  )),
                  const SizedBox(height: 12),
                  if (_meal!.youtubeUrl != null && _meal!.youtubeUrl!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _openYoutube,
                      icon: const Icon(Icons.video_library),
                      label: const Text('Open YouTube'),
                    ),
                ],
              ),
            ),
    );
  }
}