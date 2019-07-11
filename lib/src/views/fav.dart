import 'package:flutter/material.dart';
import 'package:learn_flutter/src/api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter/src/models/movie.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

Card getFavMovieCard({
  @required String title,
  @required String subtitle,
}) =>
    Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.movie),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ],
      ),
    );

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: readAsStreamStackLabsMovieFromFirestore(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return getFavMovieCard(
                        title: document['title'],
                        subtitle: document['overview'],
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
