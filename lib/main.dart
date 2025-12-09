import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'screens/categories_screen.dart';
import 'screens/meals_by_category_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/meal_detail.dart';
import 'services/firebase_service.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _initLocalNotifications() async {
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );


  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initLocalNotifications();
  await FirebaseService.instance.init();

  runApp(const MealDbApp());
}


class MealDbApp extends StatelessWidget {
  const MealDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => const CategoriesScreen(),
        FavoritesScreen.routeName: (context) => const FavoritesScreen(),
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