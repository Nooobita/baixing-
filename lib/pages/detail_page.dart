import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';
import '../pages/detail_top.dart';
import '../pages/detail_explain.dart';
import '../pages/detail_tabbar.dart';
import '../pages/detail_web.dart';
import '../pages/detail_bottom.dart'

class DetailPage extends StatelessWidget {

   final String goodsId;
   DetailPage(this.goodsId);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    DetailTop(),
                    DetailExplain(),
                    DetailTabbar(),
                    DetailWeb(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailBottom()
                )
              ],
            );
          }
          else{
            return Text('加载中...');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async{
    await Provide.value<DetailInfoProvide>(context).getGoodsInfo(goodsId);
    print("加载完了。。。。。");
  }
}