import 'package:flutter/material.dart';
import '../../core/firestore.dart';
import '../../widgets/movie_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Movies',
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: MovieSearchDelegate(),
              );
              if (query != null && query.isNotEmpty) {
                debugPrint('Navigating with query: $query'); // Debugging
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigating with query: $query')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(query: query),
                  ),
                );
              } else {
                debugPrint('Query is empty or null'); // Debugging
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Query is empty or null')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.recommend),
            tooltip: 'Recommended',
            onPressed: () {
              Navigator.pushNamed(context, '/recommendations');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          firestoreService.getTrendingMovies(),
          firestoreService.getMoviesByGenres(),
          firestoreService.getLatestTopRatedMovies(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final trendingMovies =
                snapshot.data![0] as List<Map<String, dynamic>>;
            final moviesByGenres =
                snapshot.data![1] as Map<String, List<Map<String, dynamic>>>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Latest Releases (Top Rated)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: FutureBuilder(
                        future: firestoreService.getLatestTopRatedMovies(),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No latest releases found.'));
                          } else {
                            final latestTopRatedMovies = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: latestTopRatedMovies.length,
                              itemBuilder: (context, index) {
                                final movie = latestTopRatedMovies[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/movie-details',
                                      arguments: movie,
                                    );
                                  },
                                  child: MovieCard(
                                    imageUrl: movie['poster_url'] ??
                                        'https://via.placeholder.com/150',
                                    title: movie['title'] ?? 'Unknown Title',
                                    releaseDate:
                                        movie['release_date'] ?? 'Unknown Date',
                                    description: movie['overview'] ??
                                        movie['description'],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...moviesByGenres.keys.map((genre) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            genre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: moviesByGenres[genre]!.length,
                              itemBuilder: (context, index) {
                                final movie = moviesByGenres[genre]![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/movie-details',
                                      arguments: movie,
                                    );
                                  },
                                  child: MovieCard(
                                    imageUrl: movie['poster_url'] ??
                                        'https://via.placeholder.com/150',
                                    title: movie['title'] ?? 'Unknown Title',
                                    releaseDate:
                                        movie['release_date'] ?? 'Unknown Date',
                                    description: movie['overview'] ??
                                        movie['description'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Clear search query button
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      // Custom search icon to force navigation to the SearchResultsScreen
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          if (query.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsScreen(query: query),
              ),
            );
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Removed debugging logic; instead, navigating is handled in the search button
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Displays suggestions based on the user's input
    return ListTile(
      title: Text('Search "$query"'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(query: query),
          ),
        );
      },
    );
  }
}
