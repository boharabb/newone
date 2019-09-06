import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];
  final bottomNavigationBarItemStyle = 
  TextStyle(fontSize: 9.0, color: Colors.deepOrange);
  
  CustomAppBar(){
    bottomBarItems.add(      
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home, color:Colors.cyan),
        title: Text('Home', style: bottomNavigationBarItemStyle),
        ),
        );
        bottomBarItems.add(      
      BottomNavigationBarItem(
        icon: Icon(
          Icons.search, color:Colors.cyan),
        title: Text('Search', style: bottomNavigationBarItemStyle),
        ),
        );
        bottomBarItems.add(      
      BottomNavigationBarItem(
        icon: Icon(
          Icons.add_box, color:Colors.cyan),
        title: Text('add', style: bottomNavigationBarItemStyle),
        ),
        );

  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
          child: BottomNavigationBar(
        items:bottomBarItems,
        type:BottomNavigationBarType.fixed,
      ),
    );
  }
}