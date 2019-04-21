import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/service_method.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import '../models/categoryGoods.dart';
import 'package:provide/provide.dart';
import '../models/category.dart';
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList()
              ]
            ), 
          ],
        ),
      ),
    );
  }
}

// 左侧导航栏菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    _getCategory();
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.black12)
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return _leftInKWel(index);
        },
      ),
    );
  }

  Widget _leftInKWel(int index){
    bool isClick = false;
    isClick = (index==listIndex)? true: false;

    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });

        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick? Color.fromRGBO(236, 238, 239, 1) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async {
    await request("getCategory").then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState((){
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);      
    });
  }

  void _getGoodsList({String categoryId}) async{
    var data = {
      'categoryId': categoryId == null? '4': categoryId,
      'categorySubId': '',
      'page': 1
    };
    await request('getMallGoods', data).then((val){
      var data = json.decode(val.toString());
      
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).setGoodsList(goodsList.data);
      //打印一下
      print(Provide.value<CategoryGoodsListProvide>(context).goodsList);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  // List list = ['名酒', '宝丰', '北京二锅头'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<ChildCategory>(
        builder: (context, child, childCategory){
          return Container(
            width: ScreenUtil().setWidth(570),
            height: ScreenUtil().setHeight(80),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black12))
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: childCategory.childCategoryList.length,
        itemBuilder: (context, index){
          return _rightInkWell(index, childCategory.childCategoryList[index]);
        }
      ),
          );
        },
      )
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item){
    
    bool isClick;
    isClick = (index==Provide.value<ChildCategory>(context).childIndex)?true:false;

    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildId(item.mallSubId);
        Provide.value<ChildCategory>(context).changeChildIndex(index);

        _getGoodsList(categoryId: item.mallCategoryId, mallSubId: item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            color: isClick? Colors.pink: Colors.black,
            fontSize: ScreenUtil().setSp(28))
        )
      ),
    );
  }

  void _getGoodsList({String categoryId, String mallSubId}) async{
    var data = {
      'categoryId': categoryId == null? '4': categoryId,
      'categorySubId': mallSubId == '00'? '': mallSubId,
      'page': 1
    };
    await request('getMallGoods', data).then((val){
      var data = json.decode(val.toString());
      
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).setGoodsList(goodsList.data);
      //打印一下
      print(Provide.value<CategoryGoodsListProvide>(context).goodsList);
    });
  }
}

class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data){

        print(data);
        return Expanded(
          child: Container(
          width: ScreenUtil().setWidth(570),
          child: ListView.builder(
            itemCount: (data == null)? 0 : data.goodsList.length,
            itemBuilder: (context, index){
              return _listWidget(data.goodsList,index);
            },)
          ),
        );
    });
  }

  // 商品图片
  Widget _goodsImage(list, index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  // 商品名字
  Widget _goodsName(list, index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }
  
  // 商品价格
  Widget _goodsPrice(list, index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格: ¥${list[index].presentPrice}',
            style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '¥${list[index].oriPrice}',
            style: TextStyle(color: Colors.black26,
            decoration: TextDecoration.lineThrough
          )),
        ],
      ),
    );
  }
  
  Widget _listWidget(List<CategoryGoodsListData> goodsList, int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top:5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12)
          ),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(goodsList,index),
            Column(
              children: <Widget>[
                _goodsName(goodsList,index),
                _goodsPrice(goodsList,index)
              ],
            )
          ],
        ),
      ),
    );

  }

}