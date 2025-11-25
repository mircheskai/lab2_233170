import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category.dart';


class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: category.thumb,
                  width: 120,
                  fit: BoxFit.cover,
                  placeholder: (c, _) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (c, _, __) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.description.length > 80
                            ? '${category.description.substring(0, 80)}...'
                            : category.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}