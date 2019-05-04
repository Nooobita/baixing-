import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/cartInfo.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier{
  String cartString = "[]";
  List<CartInfoModel> cartList = [];
  
  double allPrice = 0;
  int allGoodsCount = 0;
  
  bool isAllCheck = true; // 是否全选

  void save(goodsId, goodsName, count, price, images) async{
    // 初始化sharedPrefences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString("cartInfo"); // 获取持久化存储的值
    
    var temp = cartString==null? []: json.decode(cartString.toString());
    
    List<Map> tempList = List<Map>.from(temp);
    // 声明变量， 用于判断购物车中是否已存在此商品ID
    var isHave = false;
    int ival = 0;
    allPrice = 0;
    allGoodsCount = 0;

    tempList.forEach((item){
      if (item['goodsId'] == goodsId){
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }

      if (item['isCheck']){
        allPrice += (cartList[ival].count * cartList[ival].price);
        allGoodsCount += cartList[ival].count;
      }
      ival ++;
    });

    // 如果没有，增加
    if (isHave){
      Map<String, dynamic> newGoods = {
        "goodsId": goodsId,
        "goodsName": goodsName,
        "count": count,
        "price": price,
        'images': images,
        'isCheck': true
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));

      allPrice += (count * price);
      allGoodsCount += count;
    }
    // 把字符串进行encode操作
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
  }

  void remove() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    notifyListeners();
  }

  // 得到购物车中的商品
  void getCartInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if (cartString==null){
      cartList = [];
    }else{
      List<Map> tempList = List<Map>.from((json.decode(cartString.toString())));
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;

      tempList.forEach((item){
        
        if (item['isCheck']){
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        }else{
          isAllCheck = false;
        }

        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }
  // 删除单个购物车商品
  void deletedOneGoods(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString("cartInfo");
    List<Map> tempList = List<Map>.from(json.decode(cartString.toString()));

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item){
      if (item['goodsId'== goodsId]){
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  void changeCheckState(CartInfoModel cartItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString("cartInfo"); // 获取持久化的字符串
    List<Map> tempList = List<Map>.from((json.decode(cartString.toString())));
    
    int tempIndex = 0;
    int changeIndex = 0;
    
    tempList.forEach((item){
      if (item['goodsId'] ==  cartItem.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex ++;
    });

    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo(); // 重新读取列表
  }

  // 全选按钮操作
  void changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    cartString = perfs.getString("cartInfo");
    List<Map> tempList = List<Map>.from(json.decode(cartString.toString()));
    List<Map> newList = [];

    for (var item in tempList){
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    
    cartString = json.encode(newList).toString();
    perfs.setString("cartInfo", cartString);
    await getCartInfo();
  }

  // 商品数量 添加 删除
  void addOrReduceAction(CartInfoModel cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString("cartInfo");
    List<Map> tempList = List<Map>.from(json.decode(cartString.toString()));
    int tempIndex = 0;
    int changeIndex = 0;

    tempList.forEach((item){
      
      if (item['goodsId'] == cartItem.goodsId){
        changeIndex = tempIndex;
      }
      tempIndex ++ ;
    });
    if (todo == 'add'){
      cartItem.count ++ ;
    }else{
      cartItem.count -- ;
    }
    
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList.toString());
    prefs.setString("cartInfo", cartString);
    await getCartInfo();
  }
}