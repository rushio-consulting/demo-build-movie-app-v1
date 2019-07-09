import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/src/models/movie.dart';
import 'package:learn_flutter/src/api/api.dart' as rest_api;
import 'package:path_provider/path_provider.dart' as path_provider;

class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loading = true;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    // Chargement du mock de movies
    _loadMovies();
  }

  _loadMovies() async {
    MoviesResponse movieResponse = await rest_api.topRatedMovies();
    setState(() {
      movies = movieResponse.movies;
    });
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final d = await path_provider.getApplicationDocumentsDirectory();
    final favoriteFile = File('${d.path}/favorite.db');
    if (!favoriteFile.existsSync()) {
      favoriteFile.createSync();
    }

    final lines = favoriteFile.openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()); // Convert stream to individual lines.

    await for (final line in lines) {
      final movie = movies.firstWhere((m) => m.id == int.tryParse(line) ?? -1,
          orElse: () => null);
      movie?.favorite = true;
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _onTapMovie(Movie m) async {
    for (final movie in movies) {
      if (movie.id == m.id) {
        final favoriteState = movie.favorite;

        // Changement d'etat visuel dans l'application sur le setState
        setState(() {
          movie.favorite = !movie.favorite;
        });

        final d = await path_provider.getApplicationDocumentsDirectory();
        final favoriteFile = File('${d.path}/favorite.db');

        final lines = favoriteFile.openRead()
            .transform(utf8.decoder) // Decode bytes to UTF-8.
            .transform(LineSplitter()); // Convert stream to individual lines.

        if (!favoriteState) {
          favoriteFile.writeAsStringSync('${m.id}\n', mode: FileMode.append);
        } else {
          final content =
              await lines.where((line) => line != '${m.id}').toList();
          favoriteFile.writeAsStringSync(
            content.join('\n'),
            mode: FileMode.write,
          );
        }

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                Movie movie = movies[index];
                String originalTitle = movie.originalTitle;
                String releaseDate = movie.releaseDate;

                return MovieWidget(movie, _onTapMovie);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
    );
  }
}

typedef Future<void> OnTapMovie(Movie m);

// Widget sans état
class MovieWidget extends StatelessWidget {
  // Référence vers la méthode définie en typedef : OnTapMovie
  final OnTapMovie onTap;

  final Movie movie;

  MovieWidget(this.movie, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 284,
                child: Image.network(
                  'http://image.tmdb.org/t/p/w185/${movie.posterPath}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(
                movie.overview,
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          movie.releaseDate,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        movie.favorite ? Icons.star : Icons.star_border,
                        color: movie.favorite ? Colors.yellow : Colors.black,
                      ),
                      onPressed: () {
                        onTap(movie);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
