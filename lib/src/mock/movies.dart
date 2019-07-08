import 'package:learn_flutter/src/models/movie.dart';

Map<String, dynamic> _mockJson() => {
      "page": 1,
      "total_results": 3,
      "total_page": 1,
      "results": [
        {
          "release_date": "1994-09-10",
          "original_title": "The Shawshank Redemption",
        },
        {
          "release_date": "2014-10-10",
          "original_title": "Whiplash",
        },
        {
          "release_date": "1972-03-15",
          "original_title": "The Godfather",
        },
      ]
    };

// Utilisation de la factory auto générée
MoviesResponse getMockResponse() => MoviesResponse.fromJson(_mockJson());

List<Movie> getMockMovies() => getMockResponse().movies;
