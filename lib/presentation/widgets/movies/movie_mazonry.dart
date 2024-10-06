import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMazonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMazonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMazonry> createState() => _MovieMazonryState();
}

class _MovieMazonryState extends State<MovieMazonry> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        // Si no hay funcion de carga
        if (widget.loadNextPage == null) return;

        if (scrollController.position.pixels + 200 >=
            scrollController.position.maxScrollExtent) {
          // Formzamos la funcion ya que sabemos que no sera nula
          widget.loadNextPage!();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
          controller: scrollController,
          itemCount: widget.movies.length,
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            if (index == 1) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  MoviePosterLink(movie: widget.movies[index])
                ],
              );
            }
            return MoviePosterLink(movie: widget.movies[index]);
          }),
    );
  }
}
