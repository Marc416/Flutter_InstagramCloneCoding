import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/camera_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/screen_size.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedindex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  //앱의 하단 네비게이션
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.send), title: Text('')),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('')),
  ];

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
      size = MediaQuery
          .of(context)
          .size;
    }
    return Scaffold(
      key: _key,
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
    switch (index) {
    //'+' 카메라 로 사진을 찍는 스크린에 접근 할 경우
    //아예 새 창을 띄우는 것이 나음으로 카메라스크린 실행시
    //푸시로 새창을 띄운다.
      case 2:
        _openCamera();
        break;
      default:
        print(index);
        setState(() {
          _selectedindex = index;
        });
    }
  }

  void _openCamera() async {
    //기타 permission을 허용하기 위해 허용 메시지 보내기
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );
    } else {
      //허용을 안해줬을 때 디바이스에 메시지 보내기 (허용해달라고)
      //스낵바 : 하단에서 올라오는 메시지
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 접근을 허용해 주세요'),
        //스낵바는 반드시 Scaffold에서만 사용가능하
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            //스낵바 조정 시 Scaffold의 컨텍스트가 필요.
            //글로벌 키로 Scaffold에 지정 해주고 여기서 재사용.
            //복잡하다..
            //오케이버튼 누르면 현재 스낵바 사라지게하기
            _key.currentState.hideCurrentSnackBar();
            //오케이 이후 PermissionSetting창 띄우기
            AppSettings.openAppSettings();
          },
        ),
      );
      //위에서 설정한 스낵바를 실행시키는 구문, 위에서 정의하고 여기서 실행.
      _key.currentState.showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    //이게 퓨처인것을 어떻게 알았을까?..
    //API문서로 가니 How to Use가 보인다.
    Map<Permission, PermissionStatus> statuses =
    //갤러리에 접근 하는 방법이 ios, android가 다름.
    //ios : Photos, android : storage를 허가해줘야
    await [
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage
    ]
        .request();

    bool permitted = true;

    //statuses 안에 카메라 맵과 마이크 맵이 있음. 정확하게 이게 어떻게 동작하는지는 모르겠다
    //forEach -> 맵핑된 키 밸류값에 각각 접근해 다룰때
    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) permitted = false;
    });

    return permitted;
  }
}
