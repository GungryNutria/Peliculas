import 'package:flutter/material.dart';
import 'package:pelicula_v2/src/models/actores_model.dart';
import 'package:pelicula_v2/src/models/pelicula_model.dart';
import 'package:pelicula_v2/src/providers/peliculas_provider.dart';

class PeliculaDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppBar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10.0),
          _posterTitulo(context, pelicula),
          _description(pelicula),
          _crearCasting(pelicula)
        ]))
      ],
    ));
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigoAccent,
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(pelicula.title, style: TextStyle(color: Colors.white)),
          background: FadeInImage(
              placeholder: AssetImage('assets/load.gif'),
              image: NetworkImage(pelicula.getBackgroundImg()),
              fadeInDuration: Duration(milliseconds: 150),
              fit: BoxFit.cover),
        ));
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.title,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(children: [
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString())
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();
    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemCount: actores.length,
          itemBuilder: (context, i) => _actorTarget(actores[i])),
    );
  }

  Widget _actorTarget(Actor actor) {
    return Container(
        child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(actor.getPhoto()),
            placeholder: AssetImage('assets/no-image.png'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(actor.name, overflow: TextOverflow.ellipsis)
      ],
    ));
  }
}
