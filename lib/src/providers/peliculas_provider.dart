import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider{
  String _apiKey      = 'APIKEY';
  String _url         = 'api.themoviedb.org';
  String _language    = 'es-ES';
  int _popularesPage  = 0;
  bool _cargando      = false;

  List<Pelicula> _peliculasPopulares = new List();

  final _peliculasPopularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get peliculasPopularesSink => _peliculasPopularesStreamController.sink.add;

  Stream<List<Pelicula>> get peliculasPopularesStream => _peliculasPopularesStreamController.stream;

  void disposeStreams(){
    _peliculasPopularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   :   _apiKey,
      'language'  :   _language
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if(_cargando) return[];
    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   :   _apiKey,
      'language'  :   _language,
      'page'      :   _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _peliculasPopulares.addAll(resp);
    peliculasPopularesSink(_peliculasPopulares);
    _cargando = false;
    return resp;
  }  

  Future<List<Actor>> getCast(String peliId) async{
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'   :   _apiKey,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   :   _apiKey,
      'language'  :   _language,
      'query'     :   query
    });

    return await _procesarRespuesta(url);
  }
}