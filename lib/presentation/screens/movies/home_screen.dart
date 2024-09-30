import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _HomeView(),
      ),
    );
  }
}

// Usando un consumer de Stateful
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  // 1. Se pasa de State<_HomeView> a _HomeViewState
  @override
  _HomeViewState createState() => _HomeViewState();
}

// 2. Se pasa de State a ConsumerState
class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    // Llamamos a la funcion del provider
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de movies del provider
    final List<Movie> nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de peliculas (Extraidas del provider)'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: nowPlayingMovies.length,
          itemBuilder: (context, index) {
            final movie = nowPlayingMovies[index];
            return ListTile(
              title: Text(movie.title),
            );
          },
        ),
      ),
    );
  }
}
