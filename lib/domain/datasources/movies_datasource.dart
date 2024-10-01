import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDatasource {
  // Se define que metodos son exigidos para traer la data
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  // Future<List<Movie>> getNowPlaying({int page = 1});
  // Future<List<Movie>> getNowPlaying({int page = 1});
}
