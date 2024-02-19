import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/blocs/movies_bloc.dart';
import 'package:movies_app/models/item_model.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 50),
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
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'Movies, Actors, Directors...',
                    hintStyle: TextStyle(
                      color: textcolor,
                      fontSize: 18,
                    ),
                  ),
                ),
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
                        ))
                  ]),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: bloc.allMovies,
                    builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 200,
                          child: ItemsLoaded(snapshot),
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
              Image.network(widget.snapshot.data!.results[index].poster_path!),
            ],
          );
        });
  }
}
