import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  // Define la preconfiguracion de la peticion tipo Axios/Dio
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX'
      }));

  // Metodo generico para reusar
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);

    // Usamos el mapper para pasar de la clase MovieDb a la clase Movie
    final List<Movie> movies = movieDbResponse.results
        // Filtrado de solo movies con posterpath
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    // Peticion a la Api
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    // Peticion a la Api
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }
}
