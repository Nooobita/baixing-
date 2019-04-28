import 'package:flutter/material.dart';
import '../services/service_method.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';


class HomePage extends StatefulWidget {

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  String homePageContent = '正在获取数据';

  @override
  bool get wantKeepAlive => true;

  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  Widget build(BuildContext context) {

    GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();


    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
      ),
      body: FutureBuilder(
        future: request('homePageContext', {'lon': '115.02932', 'lat': '35.76189'}),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString())['data'];
            
            List <Map> swiperDataList = List<Map>.from(data['slides']);
            List <Map> navigatorList = List<Map>.from(data['category']);
            String advertesPicture = data['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['shopInfo']['leaderImage'];
            String leaderPhone = data['shopInfo']['leaderPhone'];
            List <Map> recommdList = List<Map>.from(data['recommend']);
            String floor1Title = data['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['floor3Pic']['PICTURE_ADDRESS'];
            List <Map> floor1 = List<Map>.from(data['floor1']);
            List <Map> floor2 = List<Map>.from(data['floor2']);
            List <Map> floor3 = List<Map>.from(data['floor3']);

            
            return EasyRefresh(
              child: ListView(
                children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList,),
                TopNavigator(navigatorList: navigatorList,),
                AdBanner(advertesPicture: advertesPicture,),
                LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,),
                Recommd(recommdList: recommdList,),
                FloorTitle(pictureAddress: floor1Title,),
                FloorContent(floorGoodsList: floor1,),
                FloorTitle(pictureAddress: floor2Title,),
                FloorContent(floorGoodsList: floor2,),
                FloorTitle(pictureAddress: floor3Title,),
                FloorContent(floorGoodsList: floor3,),
                _hotGoods(),

              ],
            ),
            loadMore: () async {
              print("开始加载更多");
              var formData = {"page": page};
              await request("homePageBelowContent", formData).then((val){
                var data = json.decode(val.toString());
                List<Map> newGoodsList = List<Map>.from(data['data']);
                setState(() {
                  hotGoodsList.addAll(newGoodsList);
                  page++;
                });
              });

            },
            refreshFooter: ClassicsFooter(
              key: _footerKey,
              bgColor: Colors.white,
              textColor: Colors.pink,
              moreInfoColor: Colors.pink,
              showMore: true,
              noMoreText: '',
              moreInfo: '加载中',
              loadedText: '上拉刷新',
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
 // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.black12)
      )
    ),
    child: Text('火爆专区'),
  );
  
  // 火爆专区子项
  Widget _wrapList(){
    if (hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text("¥${val['mallPrice']}"),
                    Text(
                      "¥${val['price']}",
                      style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
  
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(" ");
    }
  }

  // 火爆专区
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
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
      onTap: (){

      },
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
        physics: NeverScrollableScrollPhysics(),
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
    print(await canLaunch("tel:+8618814182468"));
    if ( await canLaunch(url)){
      launch(url);
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
      height: ScreenUtil().setHeight(300),
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
        height: ScreenUtil().setHeight(300),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1.0, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(this.recommdList[index]['image']),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('¥${recommdList[index]['mallPrice']}',),
            ),
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

// 楼层商品组件
class FloorTitle extends StatelessWidget{
  final String pictureAddress;

  FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(this.pictureAddress),
    );
  }

}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}): super(key:key); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2])
          ],
        )
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4])
      ],
    );
  }
  
  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){},
        child: Image.network(goods['image']),
      ),
    );
  }
}


