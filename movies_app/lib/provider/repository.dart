import 'package:movies_app/models/item_model.dart';
import 'package:movies_app/provider/movieapp_api_provider.dart';

class Repository {
  final movieapiprovider = ApiService();

  Future<ItemModel> fetchAllMovies() => movieapiprovider.fetchMovieList();
}
