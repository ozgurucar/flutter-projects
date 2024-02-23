import 'package:movies_app/models/genre_model.dart';
import 'package:movies_app/models/item_model.dart';
import 'package:movies_app/provider/movieapp_api_provider.dart';

class Repository {
  final movieapiprovider = ApiService();

  Future<ItemModel> fetchAllMovies() => movieapiprovider.fetchMovieList(true);
  Future<ItemModel> fetchPopularMovies() =>
      movieapiprovider.fetchPopularMovieList(false);
  Future<GenreModel> fetchAllGenres() => movieapiprovider.fetchGenresList();
}
