import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_summary.dart';
import 'firebase_service.dart';


class FavoritesService {
  FavoritesService._privateConstructor();

  static final FavoritesService instance = FavoritesService
      ._privateConstructor();


  final ValueNotifier<Set<String>> favorites = ValueNotifier({});

  Future<void> loadFavorites() async {
    final user = FirebaseService.instance.user;
    if (user == null) return;
    final snap = await FirebaseService.instance.firestore.collection('users').doc(user.uid).collection('favorites').get();
    final ids = snap.docs.map((d) => d.id).toSet();
    favorites.value = ids;
  }

  Stream<List<MealSummary>> favoritesStream() {
    final user = FirebaseService.instance.user;
    if (user == null) return const Stream.empty();
    return FirebaseService.instance.firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snap) => snap.docs.map((d) => MealSummary.fromJson(d.data())).toList());
  }

  Future<void> toggleFavorite(MealSummary meal) async {
    final user = FirebaseService.instance.user;
    if (user == null) return;
    final docRef = FirebaseService.instance.firestore.collection('users').doc(user.uid).collection('favorites').doc(meal.id);
    final exists = favorites.value.contains(meal.id);
    if (exists) {
      await docRef.delete();
      favorites.value = {...favorites.value}..remove(meal.id);
    } else {
      await docRef.set(meal.toJson());
      favorites.value = {...favorites.value}..add(meal.id);
    }
  }

  bool isFavorite(String id) => favorites.value.contains(id);
}