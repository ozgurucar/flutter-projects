import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/blocs/genre_bloc.dart';
import 'package:movies_app/blocs/movies_bloc.dart';
import 'package:movies_app/blocs/movies_popular_bloc.dart';
import 'package:movies_app/models/genre_model.dart';
import 'package:movies_app/models/item_model.dart';
import 'package:movies_app/provider/search_api.dart';
import 'package:movies_app/widgets/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    bloc_popular.fetchPopularMovies();
    bloc_genre.fetchAllGenres();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: bgcolor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Search",
                    style: GoogleFonts.alatsi(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    )),
                const SearchApi(),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(children: [
                    Positioned(
                        child: Text(
                      "Recent",
                      style: GoogleFonts.alatsi(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    )),
                    Positioned(
                        right: 20,
                        top: 4,
                        child: Text(
                          "SEE ALL",
                          style: GoogleFonts.alatsi(
                            color: textcolor,
                            fontSize: 18,
                          ),
                        )),
                  ]),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: bloc.allMovies,
                    builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 200,
                          child: ItemsLoaded(snapshot),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return const CircularProgressIndicator();
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(children: [
                    Positioned(
                        child: Text(
                      "Popular",
                      style: GoogleFonts.alatsi(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    )),
                    Positioned(
                        right: 20,
                        top: 4,
                        child: Text(
                          "SEE ALL",
                          style: GoogleFonts.alatsi(
                            color: textcolor,
                            fontSize: 18,
                          ),
                        )),
                  ]),
                ),
                StreamBuilder(
                    stream: bloc_popular.popularMovies,
                    builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 268,
                          child: StreamBuilder(
                              stream: bloc_genre.allGenres,
                              builder: (context,
                                  AsyncSnapshot<GenreModel> snapshotGenres) {
                                if (snapshot.hasData) {
                                  return PopularLoaded(
                                      snapshot, snapshotGenres);
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                return const CircularProgressIndicator();
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return const CircularProgressIndicator();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemsLoaded extends StatefulWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  const ItemsLoaded(this.snapshot, {super.key});

  @override
  State<ItemsLoaded> createState() => _ItemsLoadedState();
}

class _ItemsLoadedState extends State<ItemsLoaded> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.snapshot.data!.results.length,
        itemBuilder: (context, int index) {
          return Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 200,
                  minWidth: MediaQuery.of(context).size.width * 0.25,
                  maxHeight: 200.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.25,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                          widget.snapshot.data!.results[index].poster_path!),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.snapshot.data!.results[index].title!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          );
        });
  }
}

class PopularLoaded extends StatefulWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  final AsyncSnapshot<GenreModel> snapshotGenres;

  const PopularLoaded(this.snapshot, this.snapshotGenres, {super.key});

  @override
  State<PopularLoaded> createState() => _PopularLoadedState();
}

class _PopularLoadedState extends State<PopularLoaded> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.snapshot.data!.results.length,
        itemBuilder: (context, int index) {
          String genres = "";
          void setGenres(genres) async {
            genres = widget.snapshotGenres.data!
                .getGenre(widget.snapshot.data!.results[index].get_genre_ids);
          }

          setGenres(genres);
          return Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 350,
                  minWidth: MediaQuery.of(context).size.width * 0.50,
                  maxHeight: 350,
                  maxWidth: MediaQuery.of(context).size.width * 0.50,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                          widget.snapshot.data!.results[index].poster_path!),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.snapshot.data!.results[index].title!,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                width: MediaQuery.of(context).size.width - 20 - 220,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.snapshot.data!.results[index].get_title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.snapshot.data!.results[index].get_release_date,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        genres,
                        style: TextStyle(color: textcolor, fontSize: 14),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.snapshot.data!.results[index].get_vote_average.ceil()}/10",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
