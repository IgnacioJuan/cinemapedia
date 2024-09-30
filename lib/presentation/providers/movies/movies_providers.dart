import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  // Instanciamos y extraemos la referencia de la funcioni
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

// Definimos una funcion abstracta, el tipo que retorna y sus paramentros
typedef MovieCallback = Future<List<Movie>> Function({int page});

// Clase Generica para mantener el listado de peliculas en el provider
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  // Solicitamos una funcion abstracta
  MovieCallback fetchMoreMovies;
  // El estado Inicial es []
  // Puede crecer o implementarse una carga local del dispositivo
  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);
  //Metodos
  Future<void> loadNextPage() async {
    // Actualizamos la pagina
    currentPage++;

    // Usamos la funcion abstracta
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    // Actualiza el estado
    state = [...state, ...movies];
  }
}
