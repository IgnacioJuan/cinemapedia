import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsbyMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
        (ref) {
  final getActor = ref.watch(actorsRepositoryProvider).getActorsByMovie;

  return ActorsByMovieNotifier(getActor);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String actorId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier(this.getActors) : super({});

  Future<void> loadActors(String movieId) async {
    // Si ya existe se omite
    if (state[movieId] != null) return;
    // Buscamos la actor
    final List<Actor> actors = await getActors(movieId);
    // Agregamos al estado
    state = {...state, movieId: actors};
  }
}
