
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wallpaperhub/interceptors/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor{
  DioConnectivityRequestRetrier dioConnectivityRequestRetrier;
  RetryOnConnectionChangeInterceptor({@required this.dioConnectivityRequestRetrier});
  @override
  Future onError(DioError err) async{
    if(_shouldRetry(err)){
      try{
       return dioConnectivityRequestRetrier.scheduleRequest(err.request);
      }catch(e){
        return e.toString();
      }
    }
    return err;
  }

  bool _shouldRetry(DioError error){
    return error.error == DioErrorType.DEFAULT&&
    error.error != null && error.error is SocketException;
  }
}