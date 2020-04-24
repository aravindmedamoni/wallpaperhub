
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/data.dart';
import 'package:wallpaperhub/models/wallpaper.dart';
import 'package:wallpaperhub/views/myhomepage.dart';
import 'package:wallpaperhub/widgets/brandname.dart';

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
  List<Wallpaper> wallPapers = [];
  String searcheName;
  Future<List<Wallpaper>> futureResponse;

  Future<List<Wallpaper>> getSearchWallPapers(String searchName) async{
   // wallPapers.clear();
    var response = await http.get("https://api.pexels.com/v1/search?query=$searchName&per_page=105&page=1",headers: header);
    if(response.statusCode ==200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
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
    futureResponse = getSearchWallPapers(widget.categoryPaperAttributes.categoryName);
    super.initState();
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
                        return WallPaperCollection(
                          wallpapers: wallPapers,
                        );
                      }else{
                        return Center(child: CircularProgressIndicator(),);
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