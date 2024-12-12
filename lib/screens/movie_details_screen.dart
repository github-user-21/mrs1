import 'package:flutter/material.dart';
import 'package:mrs1/screens/recommended_films_screen.dart';
import 'package:provider/provider.dart';
import '../models/favorite_movies.dart';
import 'favorites_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.releaseDate,
  });

  final String title;
  final String description;
  final String imageUrl;
  final String releaseDate;

  void addToFavorites(FavoriteMovie movie, BuildContext context) {
    final favoritesManager =
        Provider.of<FavoritesManager>(context, listen: false);
    favoritesManager.addFavorite(movie);

    // Inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie added to favorites!')),
    );
  }

  void openRecommendationScreen(String movieTitle, BuildContext context) {
    if (movieTitle.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecommendationScreen(initialMovieTitle: movieTitle),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie title not available!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    args['imageUrl'] ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args['title'] ?? 'Unknown Title',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Release Date: ${args['releaseDate'] ?? 'Unknown Date'}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    args['description']?.isNotEmpty == true
                        ? args['description']!
                        : 'No description available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          final favoriteMovie = FavoriteMovie(
                            title: args['title'] ?? 'Unknown Title',
                            imageUrl: args['imageUrl'] ??
                                'https://via.placeholder.com/150',
                            releaseDate: args['releaseDate'] ?? 'Unknown Date',
                            description: args['overview'] ??
                                args['description'] ??
                                'No description available',
                          );
                          addToFavorites(favoriteMovie, context);
                        },
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        iconSize: 30,
                        tooltip: 'Add to Favorites',
                      ),
                      IconButton(
                        onPressed: () => openRecommendationScreen(
                          args['title'] ?? '',
                          context,
                        ),
                        icon:
                            const Icon(Icons.movie_filter, color: Colors.blue),
                        iconSize: 30,
                        tooltip: 'Similar Recommendations',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
