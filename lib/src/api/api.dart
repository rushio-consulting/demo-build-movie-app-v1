import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_flutter/src/models/movie.dart';

// C'est CADEAU pour mon API_KEY (^_^)
const String API_KEY = '4205ec1d93b1e3465f636f0956a98c64';
const String API = 'https://api.themoviedb.org/3';

/**
 * Appel à MovieDB pour récuperer la liste des films les mieux notés
 */
Future<MoviesResponse> topRatedMovies() async {
  // Path MovieDB
  final String urlPath = 'movie/top_rated';
  final String httpServerUrl = '$API/$urlPath?api_key=$API_KEY&language=fr';

  // appel asynchrone
  final http.Response response = await http.get(httpServerUrl);

  // Décoder le contenu de la response ici
  final data = json.decode(response.body);

  return MoviesResponse.fromJson(data);
}
