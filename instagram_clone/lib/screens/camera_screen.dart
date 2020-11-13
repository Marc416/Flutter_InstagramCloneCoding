import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/camera_state.dart';
import 'package:instagram_clone/models/gallery_state.dart';
import 'package:instagram_clone/widgets/my_gallery.dart';
import 'package:instagram_clone/widgets/take_photo.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  // 조정하는 프로바이더 메모리할당은 한번만.
  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();

  @override
  _CameraScreenState createState() {
    //카메라 스크린위젯 생성하자마자 카메라 상태 준비시키기.
    _cameraState.getReadyToTakePhoto();
    _galleryState.initProvider();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  static int initPagedIdx = 1;
  int _currentIndex = initPagedIdx;
  PageController _pageController = PageController(
    //페이지뷰를 처음 시작 할 때 보여주고자 하는 페이지 인덱스!
    //주의 : currentIndex 도 함께바꿔주길!
    initialPage: initPagedIdx,
  );
  String title = 'Photo';

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //providers리스트에는 singlechildwidget만 쓸 수 있으므로 ChangeNotifierProvider
        //중 CameraState의 메시지만 전달 주고 받을 수 있도록 하는 것을 아래 처럼 만든다.
        //각각 하나씩 만들어 줌으로써 파이프라인을 연결한다고 보면 될듯.
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
        ChangeNotifierProvider<GalleryState>.value(value: widget._galleryState),
      ],
      child: Scaffold(
        appBar: AppBar(
          //앱바 위젯생성시 저절로 백버튼 생성이 되는데 그 이유는
          //여기로 들어온 경로가 Navigation push로 들어 온 것이기 때문에
          //프레임워크 내에서 해당 위젯이 스택으로 위로 쌓인것을 인지하고 이전 위젯으로
          //갈 수 있는 백버튼을 자동으로 생성해줌.
          //이걸 쓰면 사라지게 할 수 있음
          // automaticallyImplyLeading: false,

          //갤러리, 비디오등등올 바뀔 꺼니까 텍스트를 변수로 받아 변경시키기
          title: Text(title),
        ),

        //페이지뷰 vs ListView vs Column
        //PageView는 스와이프를 해서 넘길 수 있는 위젯 화면임, 컨트롤러가 있어야 제대로
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            //페이지를 스와이핑해서 화면을 바꿀 때, BottomNavigation의 현재 인덱스도
            //바꾸기 위함임.
            setState(() {
              _currentIndex = index;

              //바뀌는 페이지에 따라 제목 변경
              switch (_currentIndex) {
                case 0:
                  title = 'Gallery';
                  break;
                case 1:
                  title = 'Photo';
                  break;
                case 2:
                  title = 'Video';
                  break;
              }
            });
          },
          children: [
            MyGallery(),
            TakePhoto(),
            Container(
              color: Colors.orange,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          items: <BottomNavigationBarItem>[
            //BottomNavigationBar는 아이템이 2개 이상이어야함
            BottomNavigationBarItem(
                //아이콘을 안쓸 지라도 아이콘을 지정해야 하는 위젯,
                //아이콘 이름을 안 쓸 지라도 label 속성을 꼭 기입해야 함
                icon: Icon(Icons.backspace),
                label: 'Gallery'),
            BottomNavigationBarItem(
                icon: Icon(Icons.backspace), label: 'Photo'),
            BottomNavigationBarItem(
                icon: Icon(Icons.backspace), label: 'Video'),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
    setState(
      () {
        _currentIndex = index;
        _pageController.animateToPage(_currentIndex,
            duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      },
    );
  }
}
