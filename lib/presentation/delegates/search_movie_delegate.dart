import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

// Definimos la firma, fucion que debe cumplir estas caracteristicas
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

// Extendemos y explicamos lo que retornamos en este caso el
// objeto movie opcional
class SearchMovieDelegate extends SearchDelegate<Movie?> {
  List<Movie> initialMovies;
  final SearchMoviesCallback searchMovies;
  // El StreamController solo tiene un listener, el bradcast permite mas
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  // Stream para la carga
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  // Timer para el debounce
  Timer? _debounceTimer;
  SearchMovieDelegate(
      {required this.initialMovies, required this.searchMovies});

  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    // Si esta activo, se limpia el timer e inicia nuevamente
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    //
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      // Validamos que no este vacio
      // if (query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      // Actualizamos las initialMovies
      initialMovies = movies;
      // Añade las movies
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debounceMovies.close();
    isLoadingStream.close();
  }

  Widget buildResultsAndSugestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieSearchItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  // Texto del buscador
  @override
  String get searchFieldLabel => 'Buscar película';

  // al lado de la derecha
  @override
  List<Widget>? buildActions(BuildContext context) {
    // el query es una palabra reservada del searchdelegate
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
                duration: const Duration(seconds: 15),
                spins: 10,
                infinite:
                    true, // Animacion para aparecer o quitar si no hay texto
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh_rounded)));
          }
          return FadeIn(
              animate: query
                  .isNotEmpty, // Animacion para aparecer o quitar si no hay texto
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                  onPressed: () => query = '', icon: const Icon(Icons.clear)));
        },
      ),
    ];
  }

  // Al lado izquierdo del search
  // en este caso la persiona no selecciono nada
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams;
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  // Al dar enter en la busqueda,
  // se muestra la misma data solo que usando el initialMovies...
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSugestions();
  }

  // Se dispara por cada tecla
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    return buildResultsAndSugestions();
  }
}

// Se encuentra fuera
class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        FadeIn(child: child),
                  )),
            ),
            const SizedBox(
              width: 20,
            ),
            // Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text(movie.overview.substring(0, 100))
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade900),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium
                            ?.copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
