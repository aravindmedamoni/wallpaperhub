
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class WallPaperDisplayAttributes{
  final String imagUrl;
  WallPaperDisplayAttributes({this.imagUrl});
}

class WallPaperDisplay extends StatelessWidget {
 final WallPaperDisplayAttributes wallPaperDisplayAttributes;
 WallPaperDisplay({this.wallPaperDisplayAttributes});

 //creating the channel
 static const CHANNEL_NAME = 'wallPaper';
 static const platForm = const MethodChannel(CHANNEL_NAME);
 //for saved file reference
 dynamic filePathResult;
 var context;
  BuildContext get mContext => context;
 @override
  Widget build(BuildContext context) {
   this.context = context;
    return Scaffold(
      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: wallPaperDisplayAttributes.imagUrl,
                child: Image.network(wallPaperDisplayAttributes.imagUrl, height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,fit: BoxFit.cover,)),
            Positioned(
              left: MediaQuery.of(context).size.width/6,
              right: MediaQuery.of(context).size.width/6,
              top: MediaQuery.of(context).size.height/1.4,
              bottom: MediaQuery.of(context).size.height/10,
              child: Container(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4.0),
                          child: Column(
                            children: <Widget>[
                              Text('Set WallPaper',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0)),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text('Image will be saved in gallery',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12.0))
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        _save();
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    IconButton(icon: Icon(Icons.cancel,size: 40.0,color: Colors.black,), onPressed: (){
                      Navigator.pop(context);
                    })
//                    Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

 _save() async {
  await _askPermission();
   var response = await Dio().get(wallPaperDisplayAttributes.imagUrl,
       options: Options(responseType: ResponseType.bytes));
   filePathResult =
   await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
   print(filePathResult);
   setAsWallPaper();
 }

 _askPermission() async {
   if (Platform.isIOS) {
     /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
         .requestPermissions([PermissionGroup.photos]);
   } else {
     PermissionHandler permission = PermissionHandler();
    await permission.requestPermissions([PermissionGroup.storage,PermissionGroup.camera,PermissionGroup.location]);
    await permission.checkPermissionStatus(PermissionGroup.storage);
   }
 }

 Future<void> setAsWallPaper() async{
    try{
     final int result = await platForm.invokeMethod("setWallPaper",{"text":filePathResult});
    }catch(e){
      print(e.toString());
      Navigator.pop(mContext);
    }
 }
}
