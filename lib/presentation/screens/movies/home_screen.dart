import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
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
      bottomNavigationBar: CustomBottomNavigation(),
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
    final List<Movie> slideShowMovies = ref.watch(moviesSlidesshowProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        // el delegate es una funcion para crear los slivers
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                MoviesSlideshow(movies: slideShowMovies),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayingMovies.length,
                //     itemBuilder: (context, index) {
                //       final movie = nowPlayingMovies[index];
                //       return ListTile(
                //         title: Text(movie.title),
                //       );
                //     },
                //   ),
                // ),

                MovieHorizontaListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subtitle: 'Lunes 20',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MovieHorizontaListview(
                  movies: nowPlayingMovies,
                  title: 'Proximamente',
                  subtitle: 'En este mes',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MovieHorizontaListview(
                  movies: nowPlayingMovies,
                  title: 'Populares',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MovieHorizontaListview(
                  movies: nowPlayingMovies,
                  title: 'Mejor Calificadas',
                  subtitle: 'All Times',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          },
          childCount: 1,
        ))
      ],
    );
  }
}
