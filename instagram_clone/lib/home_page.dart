import 'package:flutter/material.dart';
import 'package:instagram_clone/feed_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.send), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.access_alarm), title: Text('')),
  ];

  int _selectedindex = 0;
//  스태틱으로 설정해 둔거는 리로드 해도 안바뀌는구먼 그래서 새로 만들어야 한다
  static List<Widget> _screens = [
    FeedScreen(),
    Container(
      color: Colors.amberAccent,
    ),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.blueAccent,
    ),
    Container(
      color: Colors.blueGrey,
    ),
    Container(
      color: Colors.lightGreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: IndexedStack(
          index: _selectedindex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: btmNavItems,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          currentIndex: _selectedindex,
          onTap: _onBtmItemClick,
        ),
    );
  }

  void _onBtmItemClick(int index) {
    print(index);
    setState(() {
      _selectedindex = index;
    });
  }
}
