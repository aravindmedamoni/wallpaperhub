
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/data.dart';
import 'package:wallpaperhub/interceptors/dio_connectivity_request_retrier.dart';
import 'package:wallpaperhub/interceptors/retry_onconnection_change_interceptor.dart';
import 'package:wallpaperhub/models/wallpaper.dart';
import 'package:wallpaperhub/views/myhomepage.dart';
import 'package:wallpaperhub/widgets/brandname.dart';

class SearchWallPaperAttributes{
  final String searchQuery;
  SearchWallPaperAttributes({this.searchQuery});
}
class SearchWallPaper extends StatefulWidget {
  final SearchWallPaperAttributes searchWallPaperAttributes;
  SearchWallPaper({this.searchWallPaperAttributes});
  @override
  _SearchWallPaperState createState() => _SearchWallPaperState();
}

class _SearchWallPaperState extends State<SearchWallPaper> {
  //search controller for search for particular Collection
  TextEditingController searchController = TextEditingController();
  //create a list for the wallpapers
  List<Wallpaper> wallPapers = [];
  //string for storing the searched Collection Name
  String searchedName;
  //from this  you need to call the futureBuilder's future property
  Future<List<Wallpaper>> futureResponse;
  //create instance for Dio Package
  Dio dio;

  //method for getting the future WallPaper Collection
  Future<List<Wallpaper>> getSearchWallPapers(String searchName) async{
    wallPapers.clear();
    Response response = await dio.get("https://api.pexels.com/v1/search?query=$searchName&per_page=105&page=1", options: Options(
      headers: header
    ));
    if(response.statusCode ==200){
      Map<String,dynamic> jsonData = response.data;
      jsonData['photos'].forEach((element){
        Wallpaper wallpaper = Wallpaper();
        wallpaper = Wallpaper.fromJson(element);
        wallPapers.add(wallpaper);
      });
    }
    setState(() {

    });
    return wallPapers;

  }
  @override
  void initState() {
    dio = Dio();
   searchController.text = widget.searchWallPaperAttributes.searchQuery;
   futureResponse=getSearchWallPapers(searchController.text);
    super.initState();

//    dio.interceptors.add(RetryOnConnectionChangeInterceptor(
//        dioConnectivityRequestRetrier: (DioConnectivityRequestRetrier(dio: dio,
//            connectivity: Connectivity()))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: brandName()),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
              decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.circular(26.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value){
//                        setState(() {
//                        });
                        searchedName = value;
                        print(searchedName);
                      },
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: 'Search for wallpaper',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: (){
                      getSearchWallPapers(searchedName);
//                      setState(() {
//
//                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: FutureBuilder(
                future: futureResponse,
                  builder: (context,snapShot){
                switch(snapShot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if(snapShot.hasData){
                      return ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          WallPaperCollection(
                            wallpapers: wallPapers,
                          ),
                        ],
                      );
                    }else{
                      return Center(child: LinearProgressIndicator());
                    }
                }
                return Text("data");
              }),
            ),
          ],
        ),
      ),
    );
  }
}
