
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/data.dart';
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
  TextEditingController searchController = TextEditingController();
  List<Wallpaper> wallPapers = [];
  String searchedName;
  Future<List<Wallpaper>> futureResponse;
  
  Future<List<Wallpaper>> getSearchWallPapers(String searchName) async{
    wallPapers.clear();
    var response = await http.get("https://api.pexels.com/v1/search?query=$searchName&per_page=105&page=1",headers: header);
    if(response.statusCode ==200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
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
   searchController.text = widget.searchWallPaperAttributes.searchQuery;
   futureResponse=getSearchWallPapers(searchController.text);
    super.initState();
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
                      return Center(child: CircularProgressIndicator());
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
