import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../conf/service_url.dart';

Future request(String url, [Map formData]) async {
  try {
    print("开始获取首页接口");
    Response response;
    Dio dio = Dio();
    // 设置请求头
    // var formData = {'lon': '115.02932', 'lat': '35.76189'};
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null){
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print("Error =====> $e");
  }
}
