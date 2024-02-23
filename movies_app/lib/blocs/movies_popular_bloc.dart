// ignore_for_file: non_constant_identifier_names

import 'package:movies_app/models/item_model.dart';
import 'package:movies_app/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class PopularMoviesBloc {
  final repository = Repository();
  final movieFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get popularMovies => movieFetcher.stream;

  fetchPopularMovies() async {
    ItemModel itemModel = await repository.fetchPopularMovies();
    movieFetcher.sink.add(itemModel);
  }

  dispose() {
    movieFetcher.close();
  }
}

final bloc_popular = PopularMoviesBloc();
