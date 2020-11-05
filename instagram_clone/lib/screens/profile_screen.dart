import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/screen_size.dart';
import 'package:instagram_clone/widgets/profile_body.dart';
import 'package:instagram_clone/widgets/profile_side_menu.dart';
//클래스 바깥에 정의한 변수는 자동으로 스태틱이 된다.
//이 변수는 런타임에 변수가 생성되는게 아니고 컴파일단계에서 생성이된채로 있음.
const duration = Duration(milliseconds: 300);

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final menuWidth = size.width / 3*2;

  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXPos = 0;
  double menuXPos = size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        //SafeArea 위젯은 폰의 시간, 와이파이 등등을 보여주는 라인을저절로 제외시켜주는 기능을 가지고 있음.
        body: Stack(children: [
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(bodyXPos, 0, 0),
            curve: Curves.fastOutSlowIn,
            child:
            ProfileBody(
              //메뉴 클릭여부 메서드 구현부
              //위젯을 생성함과 동시에 메서드를 바로 구현해 놓는다.
              onMenuChanged: () {
                setState(() {
                  _menuStatus = (_menuStatus == MenuStatus.closed)
                      ? MenuStatus.opened
                      : MenuStatus.closed;
                  switch (_menuStatus) {
                    //오픈시켜라
                    case MenuStatus.opened:
                      bodyXPos = -menuWidth;
                      menuXPos = size.width - menuWidth;

                      break;
                    //클로즈시켜라
                    case MenuStatus.closed:
                      bodyXPos = 0;
                      menuXPos = size.width;
                      break;
                  }
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(menuXPos, 0, 0),
            curve: Curves.fastOutSlowIn,
            //포지션 위젯은
            child: ProfileSideMenu(menuWidth)
          ),
        ]));
  }
}

enum MenuStatus { opened, closed }
