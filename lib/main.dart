import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';
import './provide/category_goods_list.dart';
import './provide/child_category.dart';
import 'pages/index_page.dart';
import 'package:fluro/fluro.dart';
import './routers/routers.dart';
import './routers/application.dart';
import './provide/cart.dart';
import './provide/detail_info.dart';
import './provide/currentIndex.dart';

void main(){
  var childCategory = ChildCategory();
  var categoryGoodsProvide = CategoryGoodsListProvide();
  var cartProvide = CartProvide();
  var detailInfoProvide = DetailInfoProvide();
  var providers = Providers();
  var currentIndex = CurrentIndexProvide();
  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsProvide))
  ..provide(Provider<CartProvide>.value(cartProvide))
  ..provide(Provider<DetailInfoProvide>.value(detailInfoProvide))
  ..provide(Provider<CurrentIndexProvide>.value(currentIndex));
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
    Routers.configureRouters(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}