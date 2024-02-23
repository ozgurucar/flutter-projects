// ignore_for_file: non_constant_identifier_names, duplicate_ignore

// ignore: duplicate_ignore
class ItemModel {
  int? page;
  // ignore: non_constant_identifier_names
  int? total_page;
  int? total_results;
  List<Result> results = [];

  ItemModel.fromJSON(Map<String, dynamic> parsedJson, bool isRecent) {
    page = parsedJson['page'];
    total_page = parsedJson['total_page'];
    total_results = parsedJson['total_results'];
    List<Result> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }

    if (!isRecent) {
      temp.sort((a, b) {
        return b.popularity!.compareTo(a.popularity!);
      });
    } else {
      temp.sort(
        (a, b) {
          return DateTime.parse(b.release_date!)
              .compareTo(DateTime.parse(a.release_date!));
        },
      );
    }

    results = temp;
  }
}

class Result {
  String? vote_count;
  int? id;
  bool? video;
  double? vote_average;
  String? title;
  String? poster_path;
  List<int>? genre_ids = [];
  String? backdrop_path;
  String? release_date;
  bool? adult;
  double? popularity;
  String? overview;

  Result(result) {
    vote_count = result['vote_count'].toString();
    id = result['id'];
    popularity = result['popularity'];
    video = result['video'];
    vote_average = result['vote_average'];
    title = result['title'].toString();
    poster_path = "http://image.tmdb.org/t/p/w185/${result['poster_path']}";
    backdrop_path = result['backdrop_path'];
    release_date = result['release_date'];
    for (var i = 0; i < result['genre_ids'].length; i++) {
      genre_ids!.add(result['genre_ids'][i]);
    }
    adult = result['adult'];
    overview = result['overview'].toString();
  }

  String get get_release_date => release_date!;
  String get get_title => title!;
  String get get_poster_path => poster_path!;
  String get get_overview => overview!;
  double get get_vote_average => vote_average!;
  String get get_vote_count => vote_count!;
  int get get_id => id!;
  String get get_backdrop_path => backdrop_path!;
  bool get get_video => video!;
  bool get get_adult => adult!;
  List<int> get get_genre_ids => genre_ids!;
}
