import 'package:flutter/material.dart';
import '../services/service_method.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';




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
            String leaderImage = data['shopInfo']['leaderImage'];
            String leaderPhone = data['shopInfo']['leaderPhone'];
            List <Map> recommdList = List<Map>.from(data['recommend']);

            
            return SingleChildScrollView(
              child: Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList,),
                TopNavigator(navigatorList: navigatorList,),
                AdBanner(advertesPicture: advertesPicture,),
                LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,),
                Recommd(recommdList: recommdList,)
              ],
            ),
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


// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _lanuchURL,
        child: Image.network(this.leaderImage),
      ),
    );
  }
  
  void _lanuchURL() async {
    String url = 'tel:${this.leaderPhone}';
    if (await canLaunch(url)){
      await launch(url);
    } else {
      throw "cloud not launch $url";
    }
  }
}

// 商品推荐
class Recommd extends StatelessWidget{
  final List recommdList;

  Recommd({Key key, this.recommdList}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList()
        ],
      ),
    );
  }
  
  // 推荐商品标题
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0) ,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 5.0, color: Colors.black12)
        )
      ),
      child: Text("商品推荐", style: TextStyle(color: Colors.pink),),
    );
  }
  
  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.recommdList.length,
        itemBuilder: (BuildContext context, index) => _item(index),
      ),
    );
    
  }

  Widget _item(index){

    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1.0, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(this.recommdList[index]['image']),
            Text('¥${recommdList[index]['mallPrice']}'),
            Text('¥${recommdList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
                ),)
          ],
        ),
      ),
    );
  }
}
