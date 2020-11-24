import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/widgets/fade_stack.dart';
import 'package:instagram_clone/widgets/sign_in_form.dart';
import 'package:instagram_clone/widgets/sign_up_form_.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int selectedForm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Already have an account Sign in <- 이 앱이 모바일 키보드 올라올 때 안올라오게 해줌
      //키보드가 올라오면서 위젯들의 사이즈나 위치가 조정되지 않게 해줌.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            FadeStack(
              selecteForm: selectedForm,
            ),
            Positioned(
              //left, right, bottom : 양옆 바닥으로 최대한 여백이 0으로 갈 수 있게 한다!
              //현재 양쪽 모두 0이니까 가운데 정렬이 될것임.
              left: 0,
              right: 0,
              bottom: 0,
              height: 45,
              child: Container(
                color: Colors.white,
                child: FlatButton(
                  shape: Border(
                    //버튼의 그레이색상 구분선을 만드는 여러방법이 있을 수 있지만 이렇게 만들 수 잇음.
                    //그러나 shape으로 선을 그을 때는
                    //포지션의 높이를 정해줘야 FlatButton에 딱 맞게 선이 그어진다.
                    top: BorderSide(color: Colors.grey),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (selectedForm == 0) {
                          selectedForm = 1;
                        } else {
                          selectedForm = 0;
                        }
                      },
                    );
                  },
                  child: RichText(
                    //다양한 텍스트스타일을 한줄에 다 적어야 할 경우 텍스트 스팬을 쓴다.
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (selectedForm == 0)
                              ? 'Already have an account?'
                              : 'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: (selectedForm == 0) ? 'Sign up' : 'Sign in',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
