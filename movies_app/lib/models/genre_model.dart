// ignore_for_file: non_constant_identifier_names, duplicate_ignore

// ignore: duplicate_ignore
class GenreModel {
  // ignore: non_constant_identifier_names
  List<Result> results = [];

  GenreModel.fromJSON(
    Map<String, dynamic> parsedJson,
  ) {
    List<Result> temp = [];
    for (int i = 0; i < parsedJson['genres'].length; i++) {
      Result result = Result(parsedJson['genres'][i]);
      temp.add(result);
    }
    temp = temp.toSet().toList();
    results = temp;
  }

  List<Result> get getGenres => results;
  String getGenre(List<int> ids) {
    ids = ids.toSet().toList();
    String mygenre = "";
    for (var i = 0; i < ids.length; i++) {
      mygenre +=
          ("${results.where((element) => element.id == ids[i]).first.name!}, ");
    }
    mygenre = mygenre.substring(0, mygenre.length - 2);
    return mygenre;
  }
}

class Result {
  int? id;
  String? name;

  Result(result) {
    id = result['id'];
    name = result['name'];
  }

  String? get get_name => name;
  int? get get_id => id;
}
