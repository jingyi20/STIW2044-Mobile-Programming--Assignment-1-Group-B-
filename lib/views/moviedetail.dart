import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment1_movie/views/movieinfo.dart';
import 'package:assignment1_movie/views/paddingtext.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatelessWidget {
  final String movieName;
  final String imdbId;

  const MovieDetail({super.key, required this.movieName, required this.imdbId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text(movieName),
      ),
      body: FutureBuilder<MovieInfo>(
          future: getMovie(imdbId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            alignment: Alignment.center,
                            child: Image.network(
                              snapshot.data!.poster,
                              width: 200,
                            ),
                          ),
                          Center(
                              child: PaddingText(
                                  "Genre : ${snapshot.data!.genre}")),
                          const SizedBox(height: 10),
                          Text(
                            snapshot.data!.plot,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          PaddingText("Year : ${snapshot.data!.year}"),
                          PaddingText("Directed by : ${snapshot.data!.director}"),
                          PaddingText("Runtime : ${snapshot.data!.runtime}"),
                          PaddingText("Rated : ${snapshot.data!.rating}"),
                          PaddingText("IMDB Rating : ${snapshot.data!.imdbRating}"),
                          PaddingText("Meta Score : ${snapshot.data!.metaScore}"),
                        ]),
                  ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<MovieInfo> getMovie(movieId) async {
    const apiId = "12d96e88";
    final url = Uri.parse('http://www.omdbapi.com/?apikey=$apiId&i=$movieId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['Response'] == "True") {
        return MovieInfo.fromJSON(data);
      } else {
        throw Exception(data['Error']);
      }
    } else {
      throw Exception('Something went wrong !');
    }
  }
}
