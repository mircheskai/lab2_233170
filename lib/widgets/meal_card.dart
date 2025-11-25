import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_summary.dart';


class MealCard extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback? onTap;

  const MealCard({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: meal.thumb,
                  fit: BoxFit.cover,
                  placeholder: (c, _) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (c, _, __) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}