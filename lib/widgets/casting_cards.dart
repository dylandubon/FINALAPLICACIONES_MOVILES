import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:peliculasudeo/models/model.dart';
//import 'package:peliculasudeo/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/credits_respose.dart';
import '../providers/movies_provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards(this.movieId);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen :false);
    return FutureBuilder(
      future:  moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot){
        if( !snapshot.hasData){
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height:180,
            child: CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;
        return Container(
          margin:  EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount:  cast.length ,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(cast[index])),
        );
      }
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;
  const _CastCard(this.actor);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:10),
      width: 100,
      height: 80,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.fullProfilePath))
          ),
          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      )
    );

  }
}