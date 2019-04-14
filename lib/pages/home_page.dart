import 'package:flutter/material.dart';
import '../services/service_method.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString())['data'];

            print(data);

            

            List <Map> swiperDataList = List<Map>.from(data['slides']);
            List <Map> navigatorList = List<Map>.from(data['category']);
            String advertesPicture = data['advertesPicture']['PICTURE_ADDRESS'];
            
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList,),
                TopNavigator(navigatorList: navigatorList,),
                AdBanner(advertesPicture: advertesPicture,),
              ],
            );
          }
          else {
            return Center(
              child: Text("正在加载..."),
            );
          }
        },
      )
    );
  }
}

// 首页轮播图编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index){
          return Image.network("${swiperDataList[index]['image']}", fit: BoxFit.fill,);
        },
        pagination: SwiperPagination(),
        autoplay: true
      ),
    );
  }
}

// 顶部导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _getViewItemUI(BuildContext context, item){

    return InkWell(
      onTap: (){print("点解了下");},
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
    if (this.navigatorList.length > 10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) => _getViewItemUI(context, item)).toList()
      ),
    );
  }
}

// 广告栏
class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(this.advertesPicture)
    );
  }
}