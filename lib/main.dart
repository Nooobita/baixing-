import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';
import './provide/category_goods_list.dart';
import './provide/child_category.dart';
import 'pages/index_page.dart';
import 'package:fluro/fluro.dart';

void main(){
  var childCategory = ChildCategory();
  var categoryGoodsProvide = CategoryGoodsListProvide();
  var providers = Providers();
  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsProvide));
  runApp(
    ProviderNode(
      child: MyApp(),
      providers: providers
    )
  );
} 

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final router = Router();

    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}