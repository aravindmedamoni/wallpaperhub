
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioConnectivityRequestRetrier{
  final Dio dio;
  final Connectivity connectivity;
  DioConnectivityRequestRetrier({@required this.dio, @required this.connectivity});

  Future<Response> scheduleRequest(RequestOptions requestOptions) async{
    StreamSubscription subscription;
    var responseCompleter = Completer<Response>();
   subscription= connectivity.onConnectivityChanged.listen((connectivityResult) async{
      if(connectivityResult != ConnectivityResult.none){
        subscription.cancel();
       responseCompleter.complete(dio.request(
           requestOptions.path,
           options: requestOptions,
           cancelToken: requestOptions.cancelToken,
           data: requestOptions.data,
           onReceiveProgress: requestOptions.onReceiveProgress,
           onSendProgress: requestOptions.onSendProgress,
           queryParameters: requestOptions.queryParameters
       ));
      }
    });
   return responseCompleter.future;
  }
}