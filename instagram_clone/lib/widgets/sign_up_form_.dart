import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/models/firebase_auth_state.dart';
import 'package:instagram_clone/widgets/auth_input_decor.dart';
import 'package:provider/provider.dart';

import 'or_divider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

//회원가입란

class _SignUpFormState extends State<SignUpForm> {
  //글로벌키가 정확하게 무슨역할을 어떻게 하는지는 잘 모르겟다..
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    //SignUpForm 위젯 종료시 이메일 컨트롤러도 종료시켜야 한다. 그렇지 않으면 메모리 릭이 생김
    //모든 컨트롤러들은 디스포즈할 때 없애줘야함.
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //인스타그램 로고 제목과 SafeArea사이의 간격을 좀더 벌려주기 위한 사이즈박스
              SizedBox(
                height: common_l_gap,
              ),
              Image.asset('assets/images/insta_text_logo.png'),
              TextFormField(
                controller: _emailController,
                decoration: textInputDecor('Email'),
                cursorColor: Colors.black,
                //입력값 유효성 검사
                validator: (text) {
                  if (text.isNotEmpty && text.contains('@'))
                    return null;
                  else
                    return '정확한이메일 주소를 적으';
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              TextFormField(
                controller: _pwController,
                decoration: textInputDecor('Password'),
                obscureText: true,
                cursorColor: Colors.black,
                //입력값 유효성 검사
                validator: (text) {
                  if (text.isNotEmpty && text.length > 5)
                    return null;
                  else
                    return '제대로된 비밀번호를 입력해 주세';
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              TextFormField(
                controller: _cpwController,
                decoration: textInputDecor('Confirm Password'),
                obscureText: true,
                cursorColor: Colors.black,
                //입력값 유효성 검사 메서드 -> 유효성검사 콜 받을 때 실
                validator: (text) {
                  if (text.isNotEmpty && _cpwController.text == text)
                    return null;
                  else
                    return '비밀번호가 틀립니다.다시입력해 주세';
                },
              ),
              SizedBox(height: common_gap),

              _joinButton(context),
              SizedBox(height: common_gap),
              OrDivider(),
              //Facebook 로그인
              FlatButton.icon(
                onPressed: () {
                  Provider.of<FirebaseAuthState>(context, listen: false)
                      .changeFireBaseAuthStatus(FirebaseAuthStatus.signin);
                },
                //원래 아이콘과 버튼의 컬러가 검은색인데 textColor속성으로 바꿀 수 있음
                // 아마 색상 바꾸는 이름을 잘못 만든거 같다고하심.
                textColor: Colors.blue,
                icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                label: Text('Login With FaceBook'),
              )
            ],
          ),
        ),
      ),
    );
  }

  FlatButton _joinButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      //onPressed부분에 그냥 null값으로 주면 다른 위젯들의 속성들을 쓸 수가 없구나..
      onPressed: () {
        //버튼을 누르면 해당 위젯의 키의 상태 유효성 체크
        //위젯에 포함된 각각의 validate들을 실행함.
        if (_formKey.currentState.validate()) {
          //유효성검사를 모두 통과했다면
          print('Validation Success');


          //of 때문에 리슨하는거 같은데 왜 리슨하는지는 모르겠음.
          //지금 현재 위젯의 상태를 변화시키려면 리슨을 true해주면된다고함.
          Provider.of<FirebaseAuthState>(context, listen: false)
              .registerUser(context, email: _emailController.text, password: _pwController.text);

          // //Navigator, of, context 역할찾기
          // //pushReplacement -> 현재 위젯을 삭제하고 다음 위젯을 실행한다.
          // //그냥 push일 경우 현재 위젯 위에 다음 위젯을 실행한다.겹치는 거지.
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) {
          //     return HomePage();
          //   }),
          // );
        }
      },
      child: Text(
        'Join',
        style: TextStyle(color: Colors.white),
      ),
      //폼필더의 사각코너를 라운드형 만들어주는거랑, 버튼을 라운드형만들어주는 속성이 다름
      //이거 다른걸.. 일일이 어떻게 다 알아내면 좋을
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btn_border_radius)),
    );
  }

}

