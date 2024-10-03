import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;

  return MovieMapNotifier(getMovie);
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier(this.getMovie) : super({});

  Future<void> loadMovie(String movieId) async {
    // Si ya existe se omite
    if (state[movieId] != null) return;
    // Buscamos la movie
    final movie = await getMovie(movieId);
    // Agregamos al estado
    state = {...state, movieId: movie};
  }
}
