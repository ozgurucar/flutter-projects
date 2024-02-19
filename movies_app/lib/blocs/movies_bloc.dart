import 'package:movies_app/models/item_model.dart';
import 'package:movies_app/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc {
  final repository = Repository();
  final movieFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allMovies => movieFetcher.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await repository.fetchAllMovies();
    movieFetcher.sink.add(itemModel);
  }

  dispose() {
    movieFetcher.close();
  }
}

final bloc = MoviesBloc();
