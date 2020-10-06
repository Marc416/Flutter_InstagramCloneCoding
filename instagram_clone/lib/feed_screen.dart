import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/post.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
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
//      메테리얼의 차일드와 같은거같음
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: null,
              icon: ImageIcon(
//              애셋의 이미지를 가져오기
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: ImageIcon(
//              애셋의 이미지를 가져오기
                AssetImage('assets/images/actionbar_camera.png'),
                color: Colors.black87,
              ),
            )
,          ],
        ),

      ),
//    리스트안에 아이템이 30개있다는거
//    포스트들
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

