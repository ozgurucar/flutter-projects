// ignore_for_file: non_constant_identifier_names

import 'package:movies_app/models/genre_model.dart';
import 'package:movies_app/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class GenreBloc {
  final repository = Repository();
  final movieFetcher = PublishSubject<GenreModel>();

  Stream<GenreModel> get allGenres => movieFetcher.stream;

  fetchAllGenres() async {
    GenreModel itemModel = await repository.fetchAllGenres();
    movieFetcher.sink.add(itemModel);
  }

  dispose() {
    movieFetcher.close();
  }
}

final bloc_genre = GenreBloc();
