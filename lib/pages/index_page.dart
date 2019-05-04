import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'home_page.dart';
import 'member_page.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.home),
      title:Text('首页')
    ),
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.search),
      title:Text('分类')
    ),
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.shopping_cart),
      title:Text('购物车')
    ),
     BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.profile_circled),
      title:Text('会员中心')
    ),
  ];

   final List<Widget> tabBodies = [
      HomePage(),
      CategoryPage(),
      CartPage(),
      MemberPage()
   ];
   
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context,child,val){
        int currentIndex= Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items:bottomTabs,
              onTap: (index){
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
             body: IndexedStack(
                    index: currentIndex,
                    children: tabBodies
                  ),
        ); 
      }
    );
     
  }
}






// class IndexPage extends StatelessWidget{

//   // PageController _pageController;
//   final List<BottomNavigationBarItem> bottomTabs = [
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.home),
//       title: Text('首页')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.search),
//       title: Text('分类')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.shopping_cart),
//       title: Text('购物车')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.profile_circled),
//       title: Text("会员中心")
//     )
//   ];
  
//   final List<Widget> tabBodies = [
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];

//   int currentIndex = 0;
//   var currentPage;

//   // @override
//   // void initState(){
//   //   currentPage = tabBodies[currentIndex];
//   //   _pageController = PageController()
//   //   ..addListener((){
//   //     // if (currentPage != _pageController.page.round()){
//   //     //   setState(() {
//   //     //     currentPage = _pageController.page.round();
//   //     //   });
//   //     // }
//   //   });
//   //   // super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    
//     return Provide<CurrentIndexProvide>();
//     //   builder: (context, chilid, val){
//     //     return Text('111');
//     //     int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;

//     //     return Scaffold(
//     //   backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
//     //   bottomNavigationBar: BottomNavigationBar(
//     //     type: BottomNavigationBarType.fixed,
//     //     currentIndex: currentIndex,
//     //     items: bottomTabs,
//     //     onTap: (index){

//     //       // Provide.value<CurrentIndexProvide>(context).changeIndex(index);
//     //       // setState(() {
//     //       //   currentIndex=index;
//     //       //   currentPage=tabBodies[index];
//     //       // });
//     //     }
//     //   ),
//     //   body: IndexedStack(
//     //     index: currentIndex,
//     //     children: tabBodies,
//     //   ),
//     // );
//       // },
//     // );
    
    
//   }
// }