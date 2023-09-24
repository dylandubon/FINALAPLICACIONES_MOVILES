import 'package:flutter/material.dart';
//import 'package:peliculasudeo/providers/movies_provider.dart';
//import 'package:peliculasudeo/screens/screens.dart';
import 'package:provider/provider.dart';

import 'providers/movies_provider.dart';
import 'screens/details_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: true),
      ],
      child: const MyApp(), 
      );
  }
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PELICULAS DE EXAMEN',
      initialRoute: 'home',
      routes:{
        'home': ( _ ) => const HomeScreen(),
        'details': ( _ ) => const DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme:  const AppBarTheme(
          color: Colors.indigo
        )        
      )      
    );
  }
}