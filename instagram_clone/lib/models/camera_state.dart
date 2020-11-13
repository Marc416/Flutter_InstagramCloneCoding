import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraState extends ChangeNotifier {
  //내부변수 : 데이터를 외부에서 수정하지 못하게 하기
  CameraController _controller;
  CameraDescription _cameraDescription;
  bool _readyTakePhoto = false;
  //Memory leak 방지
  void dispose() {
    //컨트롤러가 있으면 없애주고
    if (_controller != null) _controller.dispose();
    //다음실
    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = false;
    notifyListeners();
  }

  // 위의 내부변수들을 외부에서 안전하게 접근 할 수 있도록 getter 만들기
  CameraController get controller => _controller;

  CameraDescription get description => _cameraDescription;

  bool get isReadyToTakePhoto => _readyTakePhoto;

  void getReadyToTakePhoto() async {
    List<CameraDescription> cameras = await availableCameras();
    //Empty는 리스트에 아무것도 없는거, null은 생성조차 안된것?
    if (cameras != null && cameras.isNotEmpty) {
      setCameraDescription(cameras[0]);
    }

    bool init = false;
    while (!init) {
      init = await initialize();
    }
    print(init);
    _readyTakePhoto = true;

    //State상태가 변경되었다고 provider한테 알려주는 notifyListner
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription, ResolutionPreset.medium);
  }

  Future<bool> initialize() async {
    try {
      await _controller.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }
}
