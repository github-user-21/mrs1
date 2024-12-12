import 'package:flutter/material.dart';
import '../core/constants.dart';
// Adjust the import if needed

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl; // Poster image URL
  final String releaseDate;
  final String description;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MovieDetailsScreen with movie data
        Navigator.pushNamed(
          context,
          '/movie-details',
          arguments: {
            'title': title,
            'description': description,
            'imageUrl': imageUrl,
            'releaseDate': releaseDate,
          },
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppConstants.defaultPadding / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                imageUrl,
                width: 150,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  AppConstants.placeholderImage,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                releaseDate,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
