import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  final String initialMovieTitle;

  const RecommendationScreen({
    super.key,
    required this.initialMovieTitle,
  });

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialMovieTitle; // Populate initial title
    if (widget.initialMovieTitle.isNotEmpty) {
      _fetchRecommendations();
    }
  }

  void _fetchRecommendations() async {
    String movie = _controller.text.trim();
    if (movie.isNotEmpty) {
      try {
        List<String> recommendations = await getMovieRecommendations(movie);
        setState(() {
          _recommendations = recommendations;
        });
      } catch (e) {
        print("Error fetching recommendations: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Recommendations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter movie title"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchRecommendations,
              child: const Text(
                "Get Recommendations",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (_recommendations.isEmpty) const Text("No recommendations yet"),
            if (_recommendations.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recommendations[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> getMovieRecommendations(String movie) async {
  final url = Uri.parse(
      'https://movie-recommendation-app-latest.onrender.com/recommend?movie=$movie');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> recommendations = List<String>.from(data['recommendations']);
      return recommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  } catch (e) {
    throw Exception('Failed to load recommendations: $e');
  }
}
