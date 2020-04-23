
import 'package:flutter/material.dart';
Widget brandName(){
  return RichText(text: TextSpan(
    children: <TextSpan>[
      TextSpan(text: "Wallpaper",style: TextStyle(color: Colors.black54,fontSize: 24,fontWeight: FontWeight.w800)),
      TextSpan(text: ' Hub',style: TextStyle(color: Colors.blue,fontSize: 22,fontWeight: FontWeight.w800))
    ]
  ),);
}