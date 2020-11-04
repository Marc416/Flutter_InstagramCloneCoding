import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/widgets/comment.dart';
import 'package:instagram_clone/widgets/my_progress_indicator.dart';
import 'package:instagram_clone/widgets/rounded_avatar.dart';

// 피드에 생성될 포스팅의 기본 UI
class Post extends StatelessWidget {
  final int index;
  Size size;

  Post(this.index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (size == null) {
//   미디어쿼리는 현재 실행되는 디바이스의화면 사이즈를 가져온다
      size = MediaQuery
          .of(context)
          .size;
    }

//  왜이걸 사용 하냐면 플러터의 이미지 위젯은 캐시하지 않는다. 메모리 저장하지 않는다
//  계속 이미지를 새로 생성한다.
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//    근데 이거 왜 위젯으로 안만들고 함수로 만든거지 -> 굳이 stl, stful 인지를 밝힐 필요가 없기 때문임.
      _postHeader(),
      _postImage(),
      _postActions(),
      _postLikes(),
      _postCaption(),
    ]);
  }

  //포스트 글 적었을 때 아이디와 내
  Widget _postCaption() {
//   한개의 텍스트안에 여러개 텍스트 스타일이 있을경우의 위젯(리치 텍스트)
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        showImage: true,
        username: 'testingUser',
        text: 'yeah',
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '12000 likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions() {
    return Row(
      children: [
        IconButton(
          icon: ImageIcon(AssetImage('assets/images/heart_selected.png')),
          color: Colors.black87,
          onPressed: null,
        ),
        IconButton(
          icon: ImageIcon(AssetImage('assets/images/comment.png')),
          color: Colors.black87,
          onPressed: null,
        ),
        IconButton(
          icon: ImageIcon(AssetImage('assets/images/direct_message.png')),
          color: Colors.black87,
          onPressed: null,
        ),
//        mainaxis를 기준으로 flexible하게 공간을 나눔 좀더 찾아봐야함 이 내용! 이거 중요
        Spacer(),
        IconButton(
          icon: ImageIcon(AssetImage('assets/images/bookmark.png')),
          color: Colors.black87,
          onPressed: null,
        ),
      ],
    );
  }

  CachedNetworkImage _postImage() {
    return CachedNetworkImage(
//    이미지를 웹에서 받아올 경우 로딩 화면보여주는 플레이스 홀더
      placeholder: (BuildContext context, String url) {
//      마이프로그레스 인디케이터에 디바이스 가로 사이즈를 넘겨서 거기서 컨테이너 사이즈지정
        return MyProgressIndicator(
          containerSize: size.width,
        );
      },
//    젤 뒤의 숫자는 가로세로 사이즈다
      imageUrl: 'https://picsum.photos/id/$index/200/200',
//    이미지의 사이즈를 조정하기 위함(위의 url이미지를 image프로바이더를 통해서 편집하겠다)
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
//        세로 / 가로 의 비율(자르는)
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                image:
                DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  //포스트의 최상단
  Widget _postHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
//      프로필 이미지를 동그랗게 할 수 있는 위젯 이걸로 감싸면됌
          child: RoundedAvatar(),
        ),
//      양옆, 위아래 컨텐츠들은 그대로 두고 expanded컨텐츠만 확장해서 화면끝까지 채우기
//      이거중요
        Expanded(
          child: Text('userName'),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
        )
      ],
    );
  }
}
