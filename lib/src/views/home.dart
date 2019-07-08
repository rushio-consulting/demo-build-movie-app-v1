import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/src/mock/movies.dart';
import 'package:learn_flutter/src/models/movie.dart';
import 'package:learn_flutter/src/api/api.dart' as rest_api;

class HomeView extends StatefulWidget {
  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<int> colorCodes = <int>[600, 500, 100];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = movies[index];
          String originalTitle = movie.originalTitle;
          String releaseDate = movie.releaseDate;

          return MovieWidget(movie);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

// Widget sans état
class MovieWidget extends StatelessWidget {

  final Movie movie;

  MovieWidget(this.movie);

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