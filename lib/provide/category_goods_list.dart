import 'package:flutter/material.dart';
import '../models/categoryGoods.dart';

class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryGoodsListData> goodsList = [];
  
  setGoodsList(List<CategoryGoodsListData> list){
    goodsList = list;
    notifyListeners();
  }
}