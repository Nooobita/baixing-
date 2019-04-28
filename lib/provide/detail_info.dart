import 'package:flutter/material.dart';
import '../models/detail.dart';
import '../services/service_method.dart';
import 'dart:convert';

class DetailInfoProvide with ChangeNotifier{
  DetailModel goodsInfo = null;
  
  // 从后台获取数据
  getGoodsInfo(String goodsId){
    var formData = {"goodsId": goodsId};
    
    request('getGoodDetailById', formData).then((val){
      var responseData = json.decode(val.toString());
      goodsInfo = DetailModel.fromJson(responseData);
    });
  }
}