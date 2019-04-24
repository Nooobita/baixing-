import 'package:flutter/material.dart';
import '../models/category.dart';

class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  int page = 1;
  String noMoreText = '';
  String mallSubId = '00';
  String categoryId = '4';
  
  // 修改大类
  getChildCategory(List<BxMallSubDto> list, String id){
    categoryId = id;
    childIndex = 0;
    page=1;
    noMoreText = '';
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
    page = 1;
    noMoreText = '';
    notifyListeners();
  }
  
  // 修改选择小类ID
  changeChildId(String mallSubId){
    mallSubId = mallSubId;
  }

  // 增加页数
  addPage(){
    page ++;
  }
  
  // 修改增加标题
  changeNoMore(String text){
    noMoreText = text;
  }
}