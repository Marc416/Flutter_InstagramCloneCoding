import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/screen_size.dart';
import 'package:instagram_clone/models/camera_state.dart';
import 'package:instagram_clone/screens/share_post_screen.dart';
import 'package:instagram_clone/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//사진 위젯이 STFUL인 이유는 매프레임마다 카메라의 화면이 바뀌는 것을 보여주어야 하기 때
class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    //Provider를 쓰는 방법 중 한가지로 Consumer!
    //CameraState를 사용할 수 있다.
    return Consumer<CameraState>(
      builder: (context, cameraState, child) {
        return Column(
          children: [
            Container(
              //화면의 가로 사이즈로... 1:1
              height: size.width,
              width: size.width,
              color: Colors.black,
              child: (cameraState.isReadyToTakePhoto)
                  ? _getPreview(cameraState)
                  : _progress,
            ),
            Expanded(
              //아웃라인만 클릭되는 버튼
              child: OutlineButton(
                onPressed: () {
                  if (cameraState.isReadyToTakePhoto) {
                    _attemptTakePhoto(cameraState, context);
                  }
                },
                //버튼모양
                shape: CircleBorder(),

                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 20,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getPreview(CameraState cameraState) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          //박스 가로에 딱 맞추기
          fit: BoxFit.fitWidth,
          child: Container(
            width: size.width,
            //[찌그러진 카메라 화면 고치]
            //왜 아스펙 ratio로 나누는거지? 저게 뭘
            height: size.width / cameraState.controller.value.aspectRatio,
            //OverflowBox -> 제한된 영역의 컨테이너를 나가게 해줌.
            child: CameraPreview(cameraState.controller),
          ),
        ),
      ),
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async {
    final String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      //join 메서드는 Path 플러그인을 쓰기위함
      //getTemporaryDirectory()메서드는 PathProvider 플러그인을 쓰기위함.
      //저장할 Path생성
      final path =
          join((await getTemporaryDirectory()).path, '$timeInMilli.png');
      //사진 찍기 기능! 및 저장
      await cameraState.controller.takePicture(path);

      File imageFile = File(path);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SharePostScreen(imageFile),
        ),
      );
    } catch (e) {}
  }
}
