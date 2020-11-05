import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/constants/screen_size.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/widgets/rounded_avatar.dart';

class ProfileBody extends StatefulWidget {
  //델리게이트 같은 역할을 하는 것으로 보임. 플러터에서는 Function이라고 하는가봄.
  final Function onMenuChanged;

  const ProfileBody({Key key, this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
//버튼 클릭 유무확인
}

enum SelectedTab { left, right }

//with <- 은 extended 와 다르게 상속하는게 아니고 그냥 가져다가 쓰는 것임. 수평적으
class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;
  AnimationController _iconAnimationController;

  //맥에서 이닛스테이트와 디스포즈를 자동완성으로 부를 수 없는 이유는?..
  @override
  void initState() {
    //this는 _ProfileBodyState의 인스턴스를 가리킨 즉 SingleTickerProviderStateMixin을 가리키는것이기도
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        // 부모의 정렬 < 차일드의 정렬 (차일드의 정렬 결정적으로을 씀  )
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //스크롤 되지 않을 것
          _appbar(),
          //슬리버 스크롤기능으로 ProfileBody위젯은 스크롤 될것
          _body(),
        ],
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

        //메뉴
        //매우중요 -> State클래스일 때 상위의 변수나 메서드에 접근하기 위해서는 'widget'키워드를 써야한다.
        IconButton(
            icon: AnimatedIcon(
              //menu_close : 메뉴에서 클로즈아이콘으로 변경, close_menu : 반대!
              //즉 변경을 무엇에서 무엇으로 할 것인지를 알려주는 것임.
              //애니메이션아이콘은 애니메이트콘트롤러를 필요로한다.
              icon: AnimatedIcons.menu_close,
              progress: _iconAnimationController,
            ),
            onPressed: () {
              widget.onMenuChanged();
              _iconAnimationController.status == AnimationStatus.completed
                  ? _iconAnimationController.reverse()
                  : _iconAnimationController.forward();
            })
      ],
    );
  }

  Widget _body() {
    return Expanded(
      //커스텀스크롤뷰 쓸 때 그리드와 리스트뷰를 혼합해서 써야 할 경우!! 인스타그램 피드처럼!
      child: CustomScrollView(
        slivers: [
          //슬리버리스트로 위젯들을 아래와 같이 감싸야 하는데 이유는 공부하다보면 알겠지.
          //현재 아래의 슬리버리스트는 그리드형 포스트위의 프로파일을 나타내는 구간임.
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Padding(
                    child: RoundedAvatar(
                      size: 80,
                    ),
                    padding: const EdgeInsets.all(common_gap),
                  ),
                  //테이블은 처음에 사이즈가 정해지지않으면 최소 사이즈를 잡음으로 사이즈를 정해준다.
                  //아래는 Expanded로 정해줌
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: common_gap),
                      child: Table(
                        children: [
                          //테이블에 아무것도 없으면 에러가 뜸으로 무언가는 넣어줘야한다.
                          TableRow(children: [
                            _valueText('111'),
                            _valueText('111'),
                            _valueText('111'),
                          ]),
                          TableRow(children: [
                            _labelText('Post'),
                            _labelText('Followers'),
                            _labelText('Following'),
                          ])
                        ],
                      ),
                    ),
                  )
                ],
              ),
              _username(),
              _userBio(),
              //에딧버튼
              _editProfileBtn(),
              // 그리드버튼과, 프로필모양의 버튼
              _tabButtons(),
              // 무엇을 클릭했는지 보여주는 아이콘 바로 아래의 인디케이터
              _selectedIndicator()
            ]),
          ),
          //슬리버의 리스트는 박스어답터로 이렇게 그리드뷰를 감싸야 쓸 수 있다.
          //슬리버를 공부할것!

          _imagePager()
        ],
      ),
    );
  }

  Text _valueText(String value) => Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );

  Text _labelText(String value) => Text(
        value,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
        textAlign: TextAlign.center,
      );

  SliverToBoxAdapter _imagePager() {
    //그리드뷰 자체를 움직이는 애니메이션을 줘야 하기 때문에 애니메이트 위젯을 사용한다.
    //두가지 그리드뷰의 애니메이션을 보여주면서 UI작업을 하기위해 Stack으로 감
    return SliverToBoxAdapter(
        child: Stack(children: [
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      ),
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      ),
    ]));
  }

  GridView _images() {
    return GridView.count(

        ///GridView와 CustomScrollView는 모두 ScrollView이다 그러므로 손가락으로
        ///화면을 터치할 시 어떤 위젯에 명령을 전달해야하는지 헷갈릴 수 있다.
        ///이럴 때에 physics를 이용해 컨트롤이가능. 현재 아래는 GridView에서 손가락
        ///명령을 받지 않도록 지정해주는 명령을 줌.
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        //todo 질문 shrinkWrap을 false로 두면 에러가 뜨는데 이게 뭔지 살펴보기
        shrinkWrap: true,
        childAspectRatio: 1,
        children: List.generate(
            30,
            (index) => CachedNetworkImage(
                //주어진 공간에 꽉차게하기.
                fit: BoxFit.fill,
                imageUrl: 'https://picsum.photos/id/$index/100/100')));
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 300,
      ),
      //바가 움직이는 애니메이션제
      curve: Curves.fastOutSlowIn,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 3,
        //공통으로 쓰는 사이즈를 불러와서 아래와 같이 조
        width: size.width / 2,
        color: Colors.black87,
      ),
    );
  }

  Row _tabButtons() {
    return Row(
      children: [
        Expanded(
          //왼쪽버튼
          child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/grid.png'),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black
                    : Colors.black26,
              ),
              //직관적인 함수 제작을 위해 매개변수로 이넘을 받는 것으로 한줄만 봐도 알 수 있게!
              //ex) 왼쪽 버튼이 클릭되었을 때의 이벤트 실행. 현재지향적!
              onPressed: () {
                _tabSelected(SelectedTab.left);
              }),
        ),
        Expanded(
          //오른쪽버튼
          child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/images/saved.png'),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black26
                    : Colors.black,
              ),
              onPressed: () {
                _tabSelected(SelectedTab.right);
              }),
        )
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    switch (selectedTab) {
      case SelectedTab.left:
        setState(() {
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
        });
        break;
      case SelectedTab.right:
        setState(() {
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
        });
        break;
    }
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: null,
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      // 패딩 주는데 왜 const를 주는거지?
      // symetric은 양 옆의 간격을 똑같이 줄
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'username',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'this is user BIo',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
