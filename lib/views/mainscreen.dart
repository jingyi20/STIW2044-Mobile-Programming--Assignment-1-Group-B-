import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:assignment1_movie/views/movie.dart';
import 'package:assignment1_movie/views/moviedetail.dart';
import 'package:assignment1_movie/views/movielist.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final searchTextController = TextEditingController();
  String searchTerm = "";

  @override
  void dispose() {
    //Dispose the controller when the screen is disposed
    searchTextController.dispose();
    super.dispose();
  }

  //When a movie is clicked the app will navigate to the movie detail screen
  void itemClick(Movie item) {
    //The movie details will be show via the list
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieDetail(
                movieName: item.title,
                imdbId: item.imdbID,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/movieicon_white.png', scale: 3),
              const Text(' My Movie App'),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(children: <Widget>[
                Flexible(
                  child: TextField(
                    //text field for user to insert the movie name
                    controller: searchTextController,
                    decoration: InputDecoration(
                        hintText: 'Enter a movie name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search Movies',
                  onPressed: () {
                    setState(() {
                      searchTerm = searchTextController.text;
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    });
                  },
                ),
              ]),
            ),
            //Only send the service request if the keyword is not empty
            if (searchTerm.isNotEmpty)
              //A future builder to render the
              FutureBuilder<List<Movie>>(
                  //Initiate the service request
                  future: searchMovies(searchTerm),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return Expanded(
                          child: MovieList(movies: data, itemClick: itemClick));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Text('');
                  }),
          ],
        ));
  }

  Future<List<Movie>> searchMovies(keyword) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Progress"), message: const Text("Seaarching..."));
    const apiId = "12d96e88";

    var url = Uri.parse('http://www.omdbapi.com/?apikey=$apiId&s=$keyword');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);

      if (data['Response'] == "True") {
        progressDialog.show();
        await Future.delayed(const Duration(seconds: 1));
        progressDialog.dismiss();

        var list = (data['Search'] as List)
            .map((item) => Movie.fromJson(item))
            .toList();
        Fluttertoast.showToast(
            msg: "Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            fontSize: 14.0);
        return list;
      } else {
        Fluttertoast.showToast(
            msg: (data['Error']),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 14.0);
        throw Exception(data['Error']);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Something went wrong !',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 14.0);
      throw Exception('Something went wrong !');
    }
  }
}
