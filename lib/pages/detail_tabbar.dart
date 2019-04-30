import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/detail_info.dart';

class DetailTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLeft = Provide.value<DetailInfoProvide>(context).isLeft;
    var isRight = Provide.value<DetailInfoProvide>(context).isRight;
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          _myTabbarLeft(context, isLeft),
          _myTabbarRight(context, isRight)
        ],
      )
    );
  }

  // 左边
  Widget _myTabbarLeft(BuildContext context, bool isLeft){
    return InkWell(
      onTap: (){
        Provide.value<DetailInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft? Colors.pink: Colors.black12
            )
          )
        ),
        child: Text(
          '详细',
          style: TextStyle(
            color: isLeft? Colors.pink: Colors.black
          ),
        ),
      ),
    );
  }

  // 右边
  Widget _myTabbarRight(BuildContext context, bool isRight){
    return InkWell(
      onTap: (){
        Provide.value<DetailInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isRight? Colors.pink: Colors.black12
            )
          )
        ),
        child: Text(
          '评论',
          style: TextStyle(
            color: isRight? Colors.pink: Colors.black
          ),
        ),
      ),
    );
  }
}