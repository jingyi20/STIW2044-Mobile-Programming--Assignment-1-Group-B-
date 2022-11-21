import 'package:assignment1_movie/views/movie.dart';
import 'package:flutter/material.dart';
import 'package:assignment1_movie/views/movieitem.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final Function itemClick;

  const MovieList({super.key, required this.movies, required this.itemClick});

  @override
  Widget build(context) {
    return Container(
        decoration: BoxDecoration(color: Colors.purple.shade100),
        child: ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  child: MovieItem(movie: movies[index]),
                  onTap: () => itemClick(movies[index]));
            }));
  }
}