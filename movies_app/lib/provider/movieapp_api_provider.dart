import 'package:dio/dio.dart';
import 'package:movies_app/models/genre_model.dart';
import 'package:movies_app/models/item_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio dio = Dio();
  final apikey = "bad1b29d902e273e03716cde67a83922";

  ApiService() {
    dio.options.baseUrl = 'https://api.themoviedb.org/3';
    dio.options.headers = {
      "accept": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYWQxYjI5ZDkwMmUyNzNlMDM3MTZjZGU2N2E4MzkyMiIsInN1YiI6IjY1YzllZDE2YWFlYzcxMDE5YjVhOTk0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.x-hxslF9cHixRVdGfJSzFkZpycK_eZwkQcAoNWpel2w"
    };
    dio.interceptors.add(PrettyDioLogger());
  }

  Future<ItemModel> fetchMovieList(bool isRecent) async {
    final response = await dio
        .get("https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey");
    if (response.statusCode == 200) {
      return ItemModel.fromJSON(response.data, isRecent);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<ItemModel> fetchPopularMovieList(bool isRecent) async {
    final response = await dio
        .get("https://api.themoviedb.org/3/movie/popular?api_key=$apikey");
    if (response.statusCode == 200) {
      return ItemModel.fromJSON(response.data, isRecent);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<GenreModel> fetchGenresList() async {
    final response = await dio
        .get("https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey");
    if (response.statusCode == 200) {
      return GenreModel.fromJSON(response.data);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
