import 'dart:async';
import 'dart:convert';
import 'package:pelicula_v2/src/models/actores_model.dart';
import 'package:pelicula_v2/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '24e4a80233477cc96fbf5d28920c1107';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _page = 0;
  bool _loading = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _processAnswer(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _processAnswer(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_loading) return [];

    _loading = true;

    _page++;

    final url = Uri.https(_url, '3/movie/popular',
        {'api_key': _apikey, 'language': _language, 'page': _page.toString()});
    final resp = await _processAnswer(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _processAnswer(url);
  }
}
