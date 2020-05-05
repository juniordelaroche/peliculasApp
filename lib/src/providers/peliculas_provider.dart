import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {

  String _apiKey      = 'cf70d497e49cc02c2443477a7cb23e0f';
  String _url         = 'api.themoviedb.org';
  String _language    = 'es-ES';
  int _popularesPage  = 0;
  bool _cargando      = false;
  // Aca creo la lista de peliculas que sera lo que fluira a traves del stream
  List<Pelicula> _populares = List();

  // sintaxis para declarar un stream
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  // con el .broadcast permito poder escuchar este stream en varios lugares de mi app

  // Get sink para decirle al stream que tipo de info va a recibir
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  // Get stream para saber que tipo de informacion me va a devolver el stream 
  Stream<List<Pelicula>> get populareStream => _popularesStreamController.stream; 

  // importante crear el metodo que cierra el stream aunque en esta app no hace falta
  void dismiss() {
    _popularesStreamController?.close();
  }

  PeliculasProvider(); //constructor

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{
    final url = Uri.https(_url, '/3/movie/now_playing', {
      'api_key'   : _apiKey,
      'language'  : _language
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    // Esta validacion es para evitar que la app haga peticiones seguidas y solo las haga cuando sea necesario
    if (_cargando) return []; 

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apiKey,
      'languaje'  : _language,
      'page'      : _popularesPage.toString()
    });
    final resp = await _procesarRespuesta(url);
    
    // Almaceno toda esa respuesta en la Lista de peliculas que cree arriba y voy añadiendo a la misma cada vez que la llame 
    _populares.addAll(resp);
    // aca mando esa lista al comienzo de mi stream
    popularesSink(_populares);

    _cargando = false;
    
    return resp;
  }
}