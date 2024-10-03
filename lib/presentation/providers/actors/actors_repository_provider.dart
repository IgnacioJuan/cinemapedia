import 'package:cinemapedia/infraestructure/datasources/actordb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

// Proveemos el repositorio
// Usamos el proveedor solo de lectura con Provider
final actorsRepositoryProvider = Provider(
  (ref) {
    // Aqui es donde se puede cambiar el datasource
    return ActorRepositoryImpl(ActordbDatasource());
  },
);
