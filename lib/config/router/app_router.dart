import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  // Anidacion de rutas
  ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) {
              return const HomeView();
            },
            routes: [
              GoRoute(
                path: 'movie/:id',
                name: MovieScreen.name,
                builder: (context, state) {
                  final String movieId = state.pathParameters['id'] ?? 'no id';
                  return MovieScreen(
                    movieId: movieId,
                  );
                },
              ),
            ]),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return const FavoritesView();
          },
        ),
      ])
  // Rutas padre/hijo
  // GoRoute(
  //     path: '/',
  //     name: HomeScreen.name,
  //     builder: (context, state) => const HomeScreen(
  //           childView: FavoritesView(),
  //         ),
  //     //rutas hijas
  //     routes: [
  //       GoRoute(
  //         path: 'movie/:id',
  //         name: MovieScreen.name,
  //         builder: (context, state) {
  //           final String movieId = state.pathParameters['id'] ?? 'no id';
  //           return MovieScreen(
  //             movieId: movieId,
  //           );
  //         },
  //       ),
  //     ]),
]);
