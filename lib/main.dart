import 'package:flutter/material.dart';
import 'package:pelicula_v2/src/pages/home_page.dart';
import 'package:pelicula_v2/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detail': (BuildContext context) => PeliculaDetail()
      },
    );
  }
}
