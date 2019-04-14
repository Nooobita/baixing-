import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../conf/service_url.dart';

Future getHomePageContent() async {
  try {
    print("开始获取首页接口");
    Response response;
    Dio dio = Dio();
    // 设置请求头
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(servicePath['homePageContext'], data: formData);
    if (response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print("Error =====> $e");
  }
}