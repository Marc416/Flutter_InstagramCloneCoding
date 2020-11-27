import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/firestore/user_model_state.dart';
import 'package:instagram_clone/repo/user_network_repository.dart';
import 'package:instagram_clone/widgets/post.dart';

//피드홈
class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header
      // 쿠퍼티노네비바는 IOS UI를 가져다 쓴 위젯임.
      appBar: CupertinoNavigationBar(
        //leading, middle, trailing -> 왼쪽, 중간, 끝부분이라는 위치를 알려
        leading: IconButton(
          onPressed: null,
          icon: Icon(
            CupertinoIcons.photo_camera_solid,
            color: Colors.black87,
          ),
        ),
        middle: Text(
          'instagram',
          style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: (){

              },
              icon: ImageIcon(
//              애셋의 이미지를 가져오기
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: (){

              },
              icon: ImageIcon(
//              애셋의 이미지를 가져오기
                AssetImage('assets/images/direct_message.png'),
                color: Colors.black87,
              ),
            )
,          ],
        ),

      ),

//    피드뷰에서 포스팅을 불러온다
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }
//아이템 수만큼 인덱스가 넘어 갈거임
  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }
}

