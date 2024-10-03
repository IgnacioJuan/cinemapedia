import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActordbDatasource extends ActorsDatasource {
  // Define la preconfiguracion de la peticion tipo Axios/Dio
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX'
      }));

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final actorDbResponse = CreditsResponse.fromJson(json);

    // Usamos el mapper para pasar de la clase actorDb a la clase actor
    final List<Actor> actors = actorDbResponse.cast
        // Filtrado de solo actors con posterpath
        .where((actordb) => actordb.profilePath != 'no-poster')
        .map((actordb) => ActorMapper.castToEntity(actordb))
        .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    // Peticion a la Api
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }
}
