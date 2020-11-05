import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

import 'constants/screen_size.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //앱의 하단 네비게이션
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.send), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('')),
  ];

  int _selectedindex = 0;

//  스태틱으로 설정해 둔거는 리로드 해도 안바뀌는구먼 그래서 새로 만들어야 한다
  static List<Widget> _screens = [
    //Home
    FeedScreen(),
    //Search
    Container(
      color: Colors.amberAccent,
    ),
    //Plus
    Container(
      color: Colors.red,
    ),
    //Message
    Container(
      color: Colors.blueAccent,
    ),
    //Profile
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //앱 실행시 가장 처음 시작되는 부분이므로 홈페이지 스크립트 빌드에서 스크린의 사이즈를 가져와 Set한다.
    if (size == null) {
//   미디어쿼리는 현재 실행되는 디바이스의화면 사이즈를 가져온다
      size = MediaQuery.of(context).size;
    }
    return Scaffold(
      //바디의 컨텐츠
      body: IndexedStack(
        //인덱스 넘버가 바뀜에 따라 children 중 그에 맞는 위젯을 실행
        index: _selectedindex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,

        //버텀 네비게이션의 속성
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
