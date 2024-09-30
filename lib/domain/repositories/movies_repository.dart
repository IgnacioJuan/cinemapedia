import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRepository {
  // Se define que metodos son exigidos para traer la data
  Future<List<Movie>> getNowPlaying({int page = 1});
}
