import 'package:flutter/material.dart';
import 'package:movies/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  const MovieSlider(
      {super.key, required this.movies, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Encabezado(name: widget.title),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(widget.movies[index],
                  '${widget.title}-$index-${widget.movies[index].id}'),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _Encabezado extends StatelessWidget {
  _Encabezado({this.name});
  String? name;

  @override
  Widget build(BuildContext context) {
    name != null ? name = name : name = 'Populares';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '$name',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster(this.movie, this.heroId);
  final Movie movie;
  final String heroId;

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: movie),
          child: Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          movie.originalTitle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
