import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/data.dart';
import 'package:wallpaperhub/interceptors/dio_connectivity_request_retrier.dart';
import 'package:wallpaperhub/interceptors/retry_onconnection_change_interceptor.dart';
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
  //list for the categories
  List<Category> categories = List();
  //list for the wallpapers
  List<Wallpaper> wallpapers = List();
  //search controller for the searching the particular collection
  TextEditingController searchController = TextEditingController();
  //from this  you need to call the futureBuilder's future property
  Future<List<Wallpaper>> futureResponse;
  //Create a reference for the Dio
  Dio dio;

  //this is the future function getting the wallpapers Collection
  Future<List<Wallpaper>> getWallpaperList() async {
    wallpapers.clear();
   Response response = await dio.get(url,options:Options(
     headers: header
   ));
    if (response.statusCode == 200) {
      // print(response.body.toString());
      Map<String, dynamic> jsonData = response.data;
      jsonData['photos'].forEach((element) {
        Wallpaper wallpaper = Wallpaper();
        wallpaper = Wallpaper.fromJson(element);
        wallpapers.add(wallpaper);
      });
    }
    setState(() {
      //for updating the wallpaperslist
      categories = getCategories();
    });
    return wallpapers;

  }

  @override
  void initState() {
    dio = Dio();
    futureResponse = getWallpaperList();
    categories = getCategories();
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
        elevation: 0.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh,size: 30,),onPressed: (){
            getWallpaperList();
          })
        ],
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
                      return Center(child: LinearProgressIndicator());
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
                    return WallPaperDisplay(wallPaperDisplayAttributes: WallPaperDisplayAttributes(imageUrl: wallpaper.src.portrait),);
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
