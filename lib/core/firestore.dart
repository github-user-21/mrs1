import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchMovies(
      String query, int page, int pageSize) async {
    try {
      // Calculate offset for pagination
      final offset = page * pageSize;

      // Query Firestore for movies matching the query
      final snapshot = await _firestore
          .collection('movies')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff') // Prefix search
          .orderBy('title') // Required for consistent pagination
          .limit(pageSize)
          .get();

      print(
          "Query executed: $query, Page: $page, PageSize: $pageSize"); // Debugging line

      // Process movies to join 'overview' list into a string
      return snapshot.docs.map((doc) {
        var movieData = doc.data();
        // Join overview if it's a list
        if (movieData.containsKey('overview') &&
            movieData['overview'] is List) {
          movieData['overview'] = (movieData['overview'] as List).join(' ');
        }
        return movieData;
      }).toList();
    } catch (e) {
      print("Error fetching movies: $e"); // Error logging
      throw Exception('Error searching movies: $e');
    }
  }

  /// Fetches the top 10 trending movies based on average votes.
  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final snapshot = await _firestore
        .collection('movies')
        .orderBy('vote_average', descending: true)
        .limit(10)
        .get();

    // Process movies to join 'overview' list into a string
    return snapshot.docs.map((doc) {
      var movieData = doc.data();
      // If overview is a list, join it into a string
      if (movieData.containsKey('overview') && movieData['overview'] is List) {
        movieData['overview'] = (movieData['overview'] as List).join(' ');
      }
      return movieData;
    }).toList();
  }

  /// Fetches movies grouped by genres, sorted by vote averages within each genre.
  Future<Map<String, List<Map<String, dynamic>>>> getMoviesByGenres() async {
    final snapshot = await _firestore.collection('movies').get();
    final movies = snapshot.docs.map((doc) {
      var movieData = doc.data();
      // Join overview if it exists as a list
      if (movieData.containsKey('overview') && movieData['overview'] is List) {
        movieData['overview'] = (movieData['overview'] as List).join(' ');
      }
      return movieData;
    }).toList();

    final genreMap = <String, List<Map<String, dynamic>>>{};

    for (var movie in movies) {
      final genres = movie['genres'] as List<dynamic>;
      for (var genre in genres) {
        if (!genreMap.containsKey(genre)) {
          genreMap[genre] = [];
        }
        genreMap[genre]!.add(movie);
      }
    }

    for (var genre in genreMap.keys) {
      genreMap[genre]!
          .sort((a, b) => b['vote_average'].compareTo(a['vote_average']));
    }

    return genreMap;
  }

  /// Fetches the latest movies sorted by release date and rating.
  Future<List<Map<String, dynamic>>> getLatestTopRatedMovies() async {
    final snapshot = await _firestore
        .collection('movies')
        .orderBy('release_date', descending: true)
        .limit(10)
        .get();

    // Process movies to join 'overview' list into a string
    return snapshot.docs.map((doc) {
      var movieData = doc.data();
      // If overview is a list, join it into a string
      if (movieData.containsKey('overview') && movieData['overview'] is List) {
        movieData['overview'] = (movieData['overview'] as List).join(' ');
      }
      return movieData;
    }).toList();
  }
}
