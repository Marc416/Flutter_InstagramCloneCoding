import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems =[
    BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.search),title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.send),title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.access_alarm),title: Text('')),
  ];

  int _selectedindex=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.amber,
        ),
        bottomNavigationBar:BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: btmNavItems,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          currentIndex: _selectedindex,
          onTap: _onBtmItemClick,
        ),
      ),
    );
  }

  void _onBtmItemClick(int index){
    print(index);
    setState(() {
      _selectedindex = index;
    });
  }
}
