import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infraestructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repostory_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* Proveedor que instancia el repositorio de almacenamiento local y lo proporciona
final localStorageRepositoryProvider = Provider(
  (ref) {
    // Retorna una implementación del repositorio de almacenamiento local usando IsarDatasource
    return LocalStorageRepostoryImp(IsarDatasource());
  },
);

//* Proveedor que gestiona el estado de si una película es favorita o no
final isFavoriteProvider =
    StateNotifierProvider.family<FavoriteNotifier, bool, int>((ref, movieId) {
  // Obtiene el repositorio de almacenamiento local desde el proveedor
  final localRespository = ref.watch(localStorageRepositoryProvider);
  // Retorna una instancia de FavoriteNotifier que gestiona el estado de la película favorita
  return FavoriteNotifier(localRespository, movieId);
});

// Clase que extiende StateNotifier para gestionar el estado de las peliculas
class FavoriteNotifier extends StateNotifier<bool> {
  final LocalStorageRepository
      _localStorageRepository; // Repositorio de almacenamiento local
  final int _movieId; // ID de la película

  // Constructor que inicializa el estado en false y carga el estado favorito desde el almacenamiento local
  FavoriteNotifier(this._localStorageRepository, this._movieId) : super(false) {
    _loadFavoriteStatus(); // Carga el estado favorito desde el almacenamiento local
  }

  // Método privado que carga el estado favorito desde el almacenamiento local
  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await _localStorageRepository.isMovieFavorite(_movieId);
    state = isFavorite; // Actualiza el estado con el valor cargado
  }

  // Método que alterna el estado favorito de una película
  Future<void> toggleFavorite(Movie movie) async {
    await _localStorageRepository
        .toggleFavorite(movie); // Alterna el estado en el almacenamiento local
    state = !state; // Alterna el estado en la UI
  }
}
