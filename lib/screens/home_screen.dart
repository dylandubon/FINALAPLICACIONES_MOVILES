


import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies/providers/movies_provider.dart';
import 'package:movies/widgets/card_swipper.dart';
import 'package:movies/widgets/movie_slider.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../search/search_delegate.dart';

Future<dynamic> main() async {
  await dotenv.load();
  runApp(const HomeScreen());
}

final auth0Web = Auth0Web('dev-xy1t1z2zss1as6c2.us.auth0.com', 'pp0AL9Nv0IoIxgWEIriP05pGuSosAI3R');

  

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) => {
        if (credentials != null) {
         

        } else {
        }
      });
    }
   
  }

  
  



  @override
  Widget build(BuildContext context) {
    final moviesProvider =  Provider.of<MoviesProvider>(context);
    var singleChildScrollView = SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper( movies: moviesProvider.onDisplayMovies),
            MovieSlider( movies: moviesProvider.popularMovies, title: "Populares", onNextPage: () => moviesProvider.getPopularMovies()),
            MovieSlider( movies: moviesProvider.upcomingMovies, title: "Upcoming", onNextPage: () => moviesProvider.getUpcomingMovies())
          ],
        ),
    );
   return Scaffold(
      appBar:  AppBar(
        title: Text("Películas en cines"),
        
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined ),
            //onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate())
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate())
          ),
          IconButton(
            icon: Icon( Icons.login),
            onPressed: () async {
            if (kIsWeb) {
              // Verifica si estás en la web antes de realizar el inicio de sesión.
              await auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000');
            } else {
              
            }
          }

      )
      ],
      ),
     
  body : singleChildScrollView
   );  
  }
}

  

  