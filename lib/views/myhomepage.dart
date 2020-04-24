import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/data.dart';
import 'package:wallpaperhub/models/category.dart';
import 'package:wallpaperhub/models/wallpaper.dart';
import 'package:wallpaperhub/views/categories.dart';
import 'package:wallpaperhub/views/searchwallpaper.dart';
import 'package:wallpaperhub/views/wallpaperdisplay.dart';
import 'package:wallpaperhub/widgets/brandname.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Category> categories = List();
  List<Wallpaper> wallpapers = List();
  TextEditingController searchController = TextEditingController();
  Future<List<Wallpaper>> futureResponse;

  Future<List<Wallpaper>> getWallpaperList() async {
    http.Response response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      // print(response.body.toString());
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData['photos'].forEach((element) {
        Wallpaper wallpaper = Wallpaper();
        wallpaper = Wallpaper.fromJson(element);
        wallpapers.add(wallpaper);
      });
    }
    return wallpapers;
//    setState(() {
//      //for updating the wallpaperslist
//    });
  }

  @override
  void initState() {
    futureResponse = getWallpaperList();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: brandName()),
        elevation: 0.0,
      ),
      body: Container(
        child: ListView(
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
                      Navigator.push(context, MaterialPageRoute(builder: (_){
                        return SearchWallPaper(searchWallPaperAttributes: SearchWallPaperAttributes(searchQuery: searchController.text),);
                      }));
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: futureResponse,
                builder: (context,snapSnot){
                switch(snapSnot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if(snapSnot.hasData){
                      return Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: categories.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return CategoryTile(
                                      categoryName: categories[index].categoryName,
                                      imageUrl: categories[index].imageUrl,
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          WallPaperCollection(
                            wallpapers: wallpapers,
                          ),
                        ],
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                }
                return Text("");
            })
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String categoryName;

  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_){
            return Categories(categoryPaperAttributes: CategoryPaperAttributes(categoryName: categoryName),);
          }));
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.fill,
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10.0)),
                  width: 120,
                  height: 100,
                  child: Center(
                    child: Text(
                      categoryName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class WallPaperCollection extends StatelessWidget {
  final List<Wallpaper> wallpapers;
  WallPaperCollection({this.wallpapers});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        physics: ClampingScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.6,
        children: wallpapers.map((wallpaper) {
          return GridTile(
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_){
                    return WallPaperDisplay(wallPaperDisplayAttributes: WallPaperDisplayAttributes(imagUrl: wallpaper.src.portrait),);
                  }));
                },
                child: Container(
                  child: Hero(
                    tag: wallpaper.src.portrait,
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                  wallpaper.src.portrait,
                  fit: BoxFit.fill,
                      loadingBuilder: (context,child,progress){
                      return progress==null?child:Container(
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.orange,
                          ));
                      },
            ),
            ),
                  ),
                ),
              ));
        }).toList(),
      ),
    );
  }
}
