import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryprovider = StateProvider((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchMovieNotifier, List<Movie>>((ref) {
  final moviesRepository = ref.read(movieRepositoryProvider);
  return SearchMovieNotifier(
      searchMovies: moviesRepository.searchMovies, ref: ref);
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieNotifier extends StateNotifier<List<Movie>> {
  SearchMoviesCallback searchMovies;

  final Ref ref;

  SearchMovieNotifier({required this.searchMovies, required this.ref})
      : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    // Peliculas para agregar al estado
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryprovider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
