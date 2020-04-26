
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperhub/data/data.dart';
import 'package:wallpaperhub/interceptors/dio_connectivity_request_retrier.dart';
import 'package:wallpaperhub/interceptors/retry_onconnection_change_interceptor.dart';
import 'package:wallpaperhub/models/wallpaper.dart';
import 'package:wallpaperhub/views/myhomepage.dart';


class CategoryPaperAttributes{
  final String categoryName;
  CategoryPaperAttributes({this.categoryName});
}
class Categories extends StatefulWidget {
  final CategoryPaperAttributes categoryPaperAttributes;
  Categories({this.categoryPaperAttributes});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  //list for wallpaper collection
  List<Wallpaper> wallPapers = [];
  //from this  you need to call the futureBuilder's future property
  Future<List<Wallpaper>> futureResponse;
  //create a instance for the dio package
  Dio dio;

  //method for getting the future WallPaper Collection
  Future<List<Wallpaper>> getSearchWallPapers(String categoryName) async{
    Response response = await dio.get("https://api.pexels.com/v1/search?query=$categoryName&per_page=105&page=1",options: Options(
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
//    setState(() {
//    });
  return wallPapers;
  }

  @override
  void initState() {
    dio = Dio();
    futureResponse = getSearchWallPapers(widget.categoryPaperAttributes.categoryName);
    super.initState();

//    dio.interceptors.add(RetryOnConnectionChangeInterceptor(
//        dioConnectivityRequestRetrier: (DioConnectivityRequestRetrier(dio: dio,
//            connectivity: Connectivity()))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: RichText(text:
              TextSpan(text: widget.categoryPaperAttributes.categoryName,style: TextStyle(color: Colors.blue,fontSize: 24,fontWeight: FontWeight.w800)),
        ),),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: FutureBuilder(
                future: futureResponse,
                  builder: (context,snapShot){
                  switch(snapShot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
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
                        return Center(child: LinearProgressIndicator(),);
                      }
                  }
                  return Text("data");
              }),
            )

          ],
        ),
      ),
    );
  }
}