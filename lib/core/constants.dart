class AppConstants {
  static const String apiBaseUrl = '';
  static const String imageBaseUrl = '';
  static const String apiKey = '';

  // API Endpoints (extendable)
  static const String trendingMoviesEndpoint = '/trending/movie/day';
  static const String movieDetailsEndpoint = '/movie'; // Append ID dynamically

  static const double defaultPadding = 16.0;
  static const String placeholderImage = '';

  static const String homeRoute = '/home';
  static const String movieDetailsRoute = '/movieDetails';
  static const String favoritesRoute = '/favorites';
  static const String recommendationsRoute = '/recommendations';

  static const String generalErrorMessage =
      'Something went wrong. Please try again letter';

  static const int primaryColorHex = 0xFF6200EE;
  static const int accentColorHex = 0xFF03DAC6;

  static int gridCrossAxisCount = 2;
}
