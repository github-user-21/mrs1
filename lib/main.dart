import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mrs1/screens/favorites_screen.dart';
import 'package:mrs1/screens/recommended_films_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_details_screen.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Using light theme
      darkTheme: AppTheme.darkTheme,
      // Support for dark mode
      themeMode: ThemeMode.system,
      // Automatically switches based on device setting
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/movie-details': (context) => const MovieDetailsScreen(
              title: '', // Placeholder value
              description: '',
              imageUrl: '',
              releaseDate: '',
            ),
        '/favorites': (context) => const FavoritesScreen(),
        '/recommendations': (context) => const RecommendationScreen(
              initialMovieTitle: 'The Avengers',
            ),
      },
    );
  }
}
