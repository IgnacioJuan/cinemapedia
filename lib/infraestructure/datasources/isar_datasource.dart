import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  // La apertura de la bd no es syncrona
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    // Se extrae el directorio usando la libreria path_provider
    final dir = await getApplicationCacheDirectory();
    if (Isar.instanceNames.isEmpty) {
      // Se le pasa los Schemas generados automaticamente al compilar el model
      // El direcotrio extraido anteriormente
      // el inspector es true para que el servcio de isart lo levante automaticamente
      return await Isar.open([MovieSchema],
          directory: dir.path, inspector: true);
    }
    // Si ya esta abierta solo la usamos
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    // Instanciamo la base
    final isar = await db;

    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return (isFavoriteMovie != null);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    // preparamos el db
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
