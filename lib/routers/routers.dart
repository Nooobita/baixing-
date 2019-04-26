import 'package:flutter/material.dart';
import './router_handle.dart';
import 'package:fluro/fluro.dart';


class Routers{
  static String root = '/';
  static String detailPage = '/detail';
  static void configureRouters(Router router){
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params){
        print("Error ====> Router was not found");
      }
    );

    router.define(detailPage, handler: detailHandler);
  } 
}