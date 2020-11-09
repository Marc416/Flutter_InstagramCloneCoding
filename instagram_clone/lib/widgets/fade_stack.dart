import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/widgets/sign_in_form.dart';
import 'package:instagram_clone/widgets/sign_up_form.dart';

class FadeStack extends StatefulWidget {
  final int selecteForm;

  const FadeStack({Key key, this.selecteForm}) : super(key: key);

  @override
  _FadeStackState createState() => _FadeStackState();
}

//SingleTickerProvider는 애니메이션 쓸 때 주로 쓰는 것임.
class _FadeStackState extends State<FadeStack>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  //로그인와 가입부분을 만들기 위해 리스트화 시키고 스택으로 두가지를 겹쳐 둔다.
  //왜냐하면 스택으로 겹쳐놔야 다른 부분에서 글을 썼을 때 안사라지고 있을 테니까
  List<Widget> forms = [SignUpForm(), SignInForm()];

  @override
  void initState() {
    //애니메이션 컨트롤러를 쓰기 위해서는 SingleTickerProviderState의 요소가 필요함! 그래서
    //with을 써서 상속비슷하게하고
    //vsync는 뭔지 모르겠지만 SingleTicker를 써야 한다고해서 this를 갖다 쓴다.
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    //
    _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FadeStack oldWidget) {
    //현재 selectedForm이 예전 위젯의 selectedForm이랑 다르다면,
    if (widget.selecteForm != oldWidget.selecteForm) {
      //from이건 잘 모르겠다.
      _animationController.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //FadeTransition 보여주려고 SingleTicker, didupdateWidget, animationController, IndexedStack 보여준거다.
    return FadeTransition(
      opacity: _animationController,
      child: IndexedStack(
        index: widget.selecteForm,
        children: forms,
      ),
    );
  }
}
