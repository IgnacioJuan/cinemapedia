import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;

// Proveemos el repositorio
// Usamos el proveedor solo de lectura con Provider
final movieRepositoryProvider = Provider(
  (ref) {
    // Aqui es donde se puede cambiar el datasource
    return MoviesRepositoryImpl(MoviedbDatasource());
  },
);
