import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = PeliculasProvider();
  
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){})
        ]
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        )
      )
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      }, 
    );

    // peliculasProvider.getEnCines();
    // return CardSwiper(
    //   peliculas: [1,2,3,4,5]
    // );
  }
  Widget _footer(BuildContext context) {
      return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Populares', style: Theme.of(context).textTheme.subhead)
            ),
            SizedBox(height: 10.0),
            StreamBuilder(
              stream: peliculasProvider.populareStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                // validamos si posee datos el snapshot
                if(snapshot.hasData) {
                  return MovieHorizontal(
                    peliculas: snapshot.data,
                    siguientePagina: peliculasProvider.getPopulares,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }               
              },
            ),
          ],
        ),
      );
  }
}