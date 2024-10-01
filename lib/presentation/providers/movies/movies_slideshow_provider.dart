import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider solo de lectura de otro provider
// Sirve para enviar solo el array recortado
final moviesSlidesshowProvider = Provider<List<Movie>>((ref) {
  final List<Movie> nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

  if (nowPlayingMovies.isEmpty) return [];

  return nowPlayingMovies.sublist(0, 6);
});
