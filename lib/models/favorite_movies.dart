class FavoriteMovie {
  final String title;
  final String imageUrl;
  final String releaseDate;
  final String description;

  FavoriteMovie({
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.description,
  });

  // Optionally add a method to convert from a map or JSON if needed
  factory FavoriteMovie.fromMap(Map<String, dynamic> map) {
    return FavoriteMovie(
      title: map['title'],
      imageUrl: map['poster_url'],
      releaseDate: map['release_date'],
      description: map['overview'] ?? map['description'] ?? 'No description available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster_url': imageUrl,
      'release_date': releaseDate,
      'overview': description,
    };
  }
}
