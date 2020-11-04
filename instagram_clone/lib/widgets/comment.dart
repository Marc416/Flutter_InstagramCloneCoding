import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/widgets/rounded_avatar.dart';


class Comment extends StatelessWidget {

  final bool showImage;
  final String username;
  final String text;
  final DateTime dateTime;

  Comment({
    Key key, this.showImage = true, @required this.username, @required this.text, this.dateTime
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //showImage를 bool값으로 넣는 이유는 댓글에서 프로필 사진 없이 코멘트만 달리는 경우도 있기 때문임 지금인스타에는 모두 프로필 보여주긴하지만..
        if(showImage)
          RoundedAvatar(size: 24),
        if(showImage)
          SizedBox(
            width: common_xxs_gap,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
//    TextSpan을 쓰면 글자색을 PrimarySwatch 색을 따라감 그래서 지금 흰색임,
//    글자색을 정해줘야 한다 여기서
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        )
                    ),
                    TextSpan(text: '   '),
                    TextSpan(
                        text: text,
                        style: TextStyle(
                            color: Colors.black87
                        )
                    ),
                  ]
              ),
            ),
            //Comment위젯 생성시 DateTime데이터가 있어야 보여줌
            if(dateTime != null)
              Text(
                dateTime.toIso8601String(),
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10
                ),
              )
          ],
        ),
      ],
    );
  }
}
