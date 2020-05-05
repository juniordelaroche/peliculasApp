import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {

    // Con esto puedo saber las dimensiones maximas de mi pantalla
    final _screenSize = MediaQuery.of(context).size;

    // controlador de mi pageview
    final _pageController = PageController(
      // Con estos atributos controlo como se ve el pageview indicando en que pagina empieza y cuantos
      // elementos mostrar 
      initialPage: 1,
      viewportFraction: 0.32
    );

    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      // De esta manera defino el 30% de alto
      height: _screenSize.height * 0.30,
      // El PageView ayuda a establecer elementos de manera horizontal y poder hacer scroll a estos
      child: PageView.builder(
        //creo un metodo que me devuelve la lista de widgets que recibe el children del PageView
        // children: _tarjetas(context),
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, i) => _tarjeta(context, peliculas[i])
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    final tarjeta = Container(
        margin: EdgeInsets.only(right: 5.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption
            )
          ],
        ),
      );

      return GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        },
        child: tarjeta
      );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   // De esta forma recorremos la lista de peliculas y devolvemos un widget con la info de cada pelicula
  //   return peliculas.map((pelicula) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 5.0),
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12.0),
  //             child: FadeInImage(
  //               image: NetworkImage(pelicula.getPosterImg()),
  //               placeholder: AssetImage('assets/img/no-image.jpg'),
  //               fit: BoxFit.cover,
  //               height: 160.0,
  //             ),
  //           ),
  //           SizedBox(height: 5.0,),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}