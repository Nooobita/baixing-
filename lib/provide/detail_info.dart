import 'package:flutter/material.dart';
import '../models/detail.dart';
import '../services/service_method.dart';
import 'dart:convert';

class DetailInfoProvide with ChangeNotifier{
  DetailModel goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;
  
  // 从后台获取数据
  getGoodsInfo(String goodsId) async{
    var formData = {"goodsId": goodsId};
    print(111);
    await request('getGoodDetailById', formData).then((val){
      var responseData = json.decode(val.toString());
      print(responseData);
      goodsInfo = DetailModel.fromJson(responseData);
      notifyListeners();

    });
  }

  // 改变tabbar的状态
  changeLeftAndRight(String changeStatus){
    if (changeStatus == 'left'){
      isLeft = true;
      isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }
  
    notifyListeners();
  }
}