import 'package:cinemapedia/infraestructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/local_storage_repostory_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Instancia al repositorio
final localStorageRepositoryProvider = Provider(
  (ref) {
    return LocalStorageRepostoryImp(IsarDatasource());
  },
);
