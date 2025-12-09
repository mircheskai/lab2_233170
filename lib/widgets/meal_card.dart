import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_summary.dart';
import '../services/favorites_service.dart';


class MealCard extends StatefulWidget {
  final MealSummary meal;
  final VoidCallback? onTap;

  const MealCard({super.key, required this.meal, this.onTap});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late final FavoritesService _fav = FavoritesService.instance;

  @override
  void initState() {
    super.initState();
    _fav.favorites.addListener(_onFavChange);
  }

  void _onFavChange() => setState(() {});

  @override
  void dispose() {
    _fav.favorites.removeListener(_onFavChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFav = _fav.isFavorite(widget.meal.id);
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: widget.meal.thumb,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (c, _) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (c, _, __) => const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: InkWell(
                      onTap: () async {
                        await _fav.toggleFavorite(widget.meal);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.meal.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}