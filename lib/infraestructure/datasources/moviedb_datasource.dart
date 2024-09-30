import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  // Define la preconfiguracion de la peticion tipo Axios/Dio
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX'
      }));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    // Peticion a la Api
    final response = await dio.get('/movie/now_playing');
    // Seteo al listado de movies MAPEADO
    final List<Movie> movies = [];
    return movies;
  }
}
