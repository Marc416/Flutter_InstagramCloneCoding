import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/gallery_state.dart';
import 'package:instagram_clone/screens/share_post_screen.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MyGallery extends StatefulWidget {
  @override
  _MyGalleryState createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    //프로바이더에서 GalleryState 가져오기
    return Consumer<GalleryState>(
      //그리드뷰를 만드는 방법은, 카운트외에도 있음.
      builder: (context, galleryState, child) {
        return GridView.count(
          //이방법은 가로로 몇개의 사진을 보여주고 스크롤 할 수 있게 할 것인지 이다.
          crossAxisCount: 3,
          children: getImages(context, galleryState),
        );
      },
    );
  }

  List<Widget> getImages(BuildContext context, GalleryState galleryState) {
    //이걸 어떻게 맵으로 하는거지..? 75강
    return galleryState.images
        .map(
          (localImage) => InkWell(
            //프로바이더로 받아온 이미지가 LocalImage형이어서
            //파일로 바꿀 수가 없음. 그래서 바이트로 변환한 뒤
            //파일로 사용하려고함.
            onTap: () async {
              Uint8List bytes = await localImage.getScaledImageBytes(
                  galleryState.localImageProvider, .3);

              final String timeInMilli =
                  DateTime.now().millisecondsSinceEpoch.toString();

              try {
                //join 메서드는 Path 플러그인을 쓰기위함
                //getTemporaryDirectory()메서드는 PathProvider 플러그인을 쓰기위함.
                //저장할 Path생성
                final path = join(
                    (await getTemporaryDirectory()).path, '$timeInMilli.png');
                // .. <- 왼쪽에 생성된 파일(File(Path))에 writeAsBytesSync메서드를 실행하겠다.
                // 실행되어 돌아온걸 imageFile로!
                File imageFile = File(path)..writeAsBytesSync(bytes);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SharePostScreen(imageFile),
                  ),
                );
              } catch (e) {}
            },
            child: Image(
              image: DeviceImage(
                localImage,
                //중요 : 스케일을 주지 않으면 원본파일로 불러오기 때문에 느려진다.
                //그러므로 아래와 같이 스케일을 꼭 줘야 갤러리에서 버벅임이 사라짐
                scale: 0.1,
              ),
              //이미지를 정사각형으로 잘라줌.
              fit: BoxFit.cover,
            ),
          ),
        )
        .toList();
  }
}
