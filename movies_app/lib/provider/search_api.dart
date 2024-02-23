// ignore_for_file: sized_box_for_whitespace

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/widgets/constants.dart';
import 'movieapp_api_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchApi extends StatefulWidget {
  const SearchApi({super.key});

  @override
  State<SearchApi> createState() => _SearchApiState();
}

class _SearchApiState extends State<SearchApi> {
  List<Map<String, dynamic>> searchResult = [];
  final TextEditingController searchText = TextEditingController();
  bool showList = false;
  var val1;

  Future<void> searchListFunction(val) async {
    var searchURL =
        "https://api.themoviedb.org/3/search/multi?api_key=bad1b29d902e273e03716cde67a83922&query=$val";
    var searchResponse = await Dio().get(searchURL);

    if (searchResponse.statusCode == 200) {
      var searchJson = searchResponse.data['results'];
      print("searched" + searchResponse.toString());
      for (var item in searchJson) {
        if (item['id'] != null &&
            item['poster_path'] != null &&
            item['vote_average'] != null &&
            item['media_type'] != null &&
            item['title'] != null) {
          searchResult.add({
            'id': item['id'],
            'poster_path': item['poster_path'],
            'popularity': item['popularity'],
            'overview': item['overview'],
            'title': item['title'],
          });

          if (searchResult.length > 20) {
            searchResult.removeRange(20, searchResult.length);
          }
        } else {
          print("Null value");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width,
            child: TextField(
              controller: searchText,
              autofocus: false,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                        textColor: Colors.white,
                        fontSize: 16,
                        msg: 'Search Cleared');
                    setState(() {
                      searchText.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: textcolor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textcolor,
                ),
                border: const UnderlineInputBorder(),
                hintText: 'Movies, Actors, Directors...',
                hintStyle: TextStyle(
                  color: textcolor,
                  fontSize: 18,
                ),
              ),
              onSubmitted: (value) {
                searchResult.clear();
                setState(() {
                  val1 = value;
                  print("val1" + val1);
                });
              },
              onChanged: (value) {
                searchResult.clear();
                setState(() {
                  val1 = value;
                  print("val1" + val1);
                });
              },
            ),
          ),
          SizedBox(height: 5),
          if (searchText.text.length > 0)
            FutureBuilder(
                future: searchListFunction(val1),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: searchResult.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Text(
                            searchResult[index]['title'].toString(),
                            style: TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }))
        ],
      ),
    );
  }
}
