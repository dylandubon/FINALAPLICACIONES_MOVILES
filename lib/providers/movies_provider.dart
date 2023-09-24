// ignore_for_file: duplicate_import

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movies/helpers/debouncer.dart';
import 'package:movies/models/credits_respose.dart';
import 'package:movies/models/movie.dart';
//import 'dart:async';

//import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:peliculasudeo/helpers/debouncer.dart';
//import 'package:peliculasudeo/models/model.dart';
//import 'package:peliculasudeo/models/popular_response.dart';
import 'package:http/http.dart' as http;
//import 'package:movies/screens/home_screen.dart';

import '../models/now_playing_response.dart';
import '../models/popular_response.dart';
import '../models/search_response.dart';
///import 'package:peliculasudeo/models/search_response.dart';
//import 'package:peliculasudeo/models/search_response.dart';


/*Future<dynamic> main() async {
  await dotenv.load();
  runApp(const HomeScreen());
}
*/
class MoviesProvider extends ChangeNotifier {

  String _apiKey   = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];
  List<Movie> upcomingMovies = [];

  Map<int, List<Cast>> moviesCast = {};
    
  int _popularPage = 0;
  int _upcomingPage = 0;

  final debouncer = Debouncer(
    duration: Duration( milliseconds: 500 ),
  );

  final StreamController<List<Movie>> _suggestionStreamContoller = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamContoller.stream;



  MoviesProvider() {
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
    this.getUpcomingMovies();

  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }


  getOnDisplayMovies() async {
    
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;
    
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage );
    final popularResponse = PopularResponse.fromJson( jsonData );
    
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    notifyListeners();
  }
//mira aquí 

getUpcomingMovies() async {

    _upcomingPage++;

    final jsonData = await this._getJsonData('3/movie/upcoming', _upcomingPage );
    final upcomingResponse = PopularResponse.fromJson( jsonData );
    
    upcomingMovies = [ ...upcomingMovies, ...upcomingResponse.results ];
    notifyListeners();
  }


  Future<List<Cast>> getMovieCast( int movieId ) async {

    if( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamContoller.add( results );
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }


}