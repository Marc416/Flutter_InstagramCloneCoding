import 'package:flutter/foundation.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart';

class GalleryState extends ChangeNotifier {
  //프로바이더플러그인에서 가져옴.
  //디바이스로부터 바로 기능을 불러올 수 있게 해주는 등 아주 편리한거 같음.
  LocalImageProvider _localImageProvider;
  //로컬이미지 플러그인
  List<LocalImage> _images;
  bool _hasPermission;

  //Getter
  LocalImageProvider get localImageProvider => _localImageProvider;
  List<LocalImage> get images => _images;
  bool get hasPermission => _hasPermission;

  Future<bool> initProvider() async {
    _localImageProvider = LocalImageProvider();
    //initialize -> 프로바이드가 디바이스 에 접근 하는 것을 시작함!
    _hasPermission = await _localImageProvider.initialize();
    if (_hasPermission) {
      //로컬이미지 프로바이더가 기기내부 갤러리 이미지중 최근 30개를 불러온다
      _images = await _localImageProvider.findLatest(30);

      return true;
    } else {
      return false;
    }
  }
}
