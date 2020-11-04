import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      //SafeArea 위젯은 폰의 시간, 와이파이 등등을 보여주는 라인을저절로 제외시켜주는 기능을 가지고 있음.
      body: SafeArea(
        child: Column(
          children: [_appbar()],
        ),
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.backspace), onPressed: null),
        Expanded(
            child: Text(
          'hey',
          textAlign: TextAlign.center,
        )),
        IconButton(icon: Icon(Icons.menu), onPressed: null)
      ],
    );
  }
}
