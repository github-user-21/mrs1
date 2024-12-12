import 'package:flutter/material.dart';

import '../core/firestore.dart';
import '../widgets/movie_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> movies = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1; // Start with the first page
  final int pageSize = 20; // Number of movies per page

  @override
  void initState() {
    super.initState();
    _fetchMovies();

    // Add listener to detect when user scrolls near the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetchMovies();
      }
    });
  }

  Future<void> _fetchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch movies for the current page
      final newMovies = await firestoreService.searchMovies(
        widget.query,
        currentPage,
        pageSize,
      );

      setState(() {
        currentPage++;
        movies.addAll(newMovies);
        isLoading = false;

        // If fewer movies are returned than the page size, we've reached the end
        if (newMovies.length < pageSize) {
          hasMore = false;
        }
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movies: $error')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
      ),
      body: movies.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : movies.isEmpty
              ? const Center(child: Text('No movies found.'))
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 2 / 3, // Adjust for card dimensions
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          final imageUrl = movie['poster_url'] ??
                              'https://via.placeholder.com/150';
                          final title = movie['title'] ?? 'Unknown Title';
                          final releaseDate =
                              movie['release_date'] ?? 'Unknown Date';
                          final description = movie['overview'] ??
                              movie['description'] ??
                              'No description available';

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/movie-details',
                                arguments: movie,
                              );
                            },
                            child: MovieCard(
                              imageUrl: imageUrl,
                              title: title,
                              releaseDate: releaseDate,
                              description: description,
                            ),
                          );
                        },
                      ),
                    ),
                    if (isLoading && hasMore)
                      const Positioned(
                        bottom: 16.0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
    );
  }
}
