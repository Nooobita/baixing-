import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  String mallSubId = '00';
  
  // 修改大类
  getChildCategory(List<BxMallSubDto> list){
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }
  
  // 修改小类
  changeChildIndex(index){
    childIndex = index;
    notifyListeners();
  }
  
  // 修改选择小类ID
  changeChildId(String mallSubId){
    mallSubId = mallSubId;
  }

}