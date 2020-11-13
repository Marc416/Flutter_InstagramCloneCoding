import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/home_page.dart';
import 'package:instagram_clone/widgets/or_divider.dart';

import 'auth_input_decor.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(common_gap),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: common_l_gap,
            ),
            Image.asset('assets/images/insta_text_logo.png'),
            TextFormField(
              cursorColor: Colors.black,
              controller: _emailController,
              decoration: textInputDecor('Email'),
              validator: (text) {
                if (text.isNotEmpty && text.length > 5)
                  return null;
                else
                  return '제대로된 비밀번호를 입력해 주세';
              },
            ),
            SizedBox(
              height: common_gap,
            ),
            TextFormField(
              cursorColor: Colors.black,
              controller: _pwController,
              decoration: textInputDecor('Pass Word'),
              validator: (text) {
                if (text.isNotEmpty && _pwController.text == text)
                  return null;
                else
                  return '비밀번호가 틀립니다.다시입력해 주세';
              },
            ),
            SizedBox(
              height: common_gap,
            ),
            _loginButton(context),
            FlatButton(
              onPressed: null,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'ForGotten Password',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              height: common_gap,
            ),
            OrDivider(),
            FlatButton.icon(
              onPressed: () {},
              //원래 아이콘과 버튼의 컬러가 검은색인데 textColor속성으로 바꿀 수 있음
              // 아마 색상 바꾸는 이름을 잘못 만든거 같다고하심.
              textColor: Colors.blue,
              icon: ImageIcon(AssetImage('assets/images/facebook.png')),
              label: Text('Login With FaceBook'),
            )
          ],
        ),
      ),
    );
  }

  FlatButton _loginButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      },
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
