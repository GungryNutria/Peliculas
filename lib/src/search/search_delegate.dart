import 'package:flutter/material.dart';
import 'package:pelicula_v2/src/models/pelicula_model.dart';
import 'package:pelicula_v2/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shasam',
    'Capitan America',
    'Thore'
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las Acciones de nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: AnimatedIcon(
            progress: transitionAnimation, icon: AnimatedIcons.menu_arrow));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/no-image.png'),
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.popularity.toString()),
              onTap: () {
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, 'detail', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
