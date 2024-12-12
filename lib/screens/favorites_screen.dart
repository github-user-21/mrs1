import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/favorite_movies.dart';
import '../widgets/movie_card.dart';

class FavoritesManager extends ChangeNotifier {
  final List<FavoriteMovie> _favoriteMovies = [];
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<FavoriteMovie> get favoriteMovies => List.unmodifiable(_favoriteMovies);

  // Fetch favorite movies from Firebase Firestore
  Future<void> fetchFavorites() async {
    try {
      final snapshot = await _firebaseFirestore.collection('favorites').get();
      _favoriteMovies.clear(); // Clear the existing list
      for (var doc in snapshot.docs) {
        _favoriteMovies.add(FavoriteMovie(
          title: doc['title'],
          imageUrl: doc['imageUrl'],
          releaseDate: doc['releaseDate'],
          description: doc['overview'] ?? doc['description'],
        ));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  // Add movie to favorites in Firebase Firestore
  Future<void> addFavorite(FavoriteMovie movie) async {
    try {
      // Check if the movie is already in Firestore
      final docSnapshot = await _firebaseFirestore
          .collection('favorites')
          .doc(movie.title)
          .get();
      if (!docSnapshot.exists) {
        // Add the movie to Firestore if not already present
        await _firebaseFirestore.collection('favorites').doc(movie.title).set({
          'title': movie.title,
          'imageUrl': movie.imageUrl,
          'releaseDate': movie.releaseDate,
          'description': movie.description,
        });
        _favoriteMovies.add(movie); // Add to local list
        notifyListeners();
      }
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesManager = context.watch<FavoritesManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: favoritesManager.favoriteMovies.isEmpty
            ? const Center(
                child: Text('No favorites yet!'),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: favoritesManager.favoriteMovies.length,
                itemBuilder: (context, index) {
                  final movie = favoritesManager.favoriteMovies[index];
                  return MovieCard(
                    imageUrl: movie.imageUrl,
                    title: movie.title,
                    releaseDate: movie.releaseDate,
                    description: movie.description,
                  );
                },
              ),
      ),
    );
  }
}
