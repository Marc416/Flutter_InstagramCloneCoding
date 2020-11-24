import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/material_white.dart';
import 'package:instagram_clone/models/firebase_auth_state.dart';
import 'package:instagram_clone/screens/auth_screen.dart';
import 'package:instagram_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _fireBaseAuthState = FirebaseAuthState();


  //페이지전환시 애니메이션넣기위한 변수
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _fireBaseAuthState.watchAuthChange();
    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _fireBaseAuthState,
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(
          builder: (context, firebaseAuthState, child) {
            switch (firebaseAuthState.firebaseAuthStatus) {
              case FirebaseAuthStatus.signout:
                _currentWidget = AuthScreen();
                break;
              case FirebaseAuthStatus.signin:
                _currentWidget = HomePage();
                break;
              default:
                //이부분 자동완성이 잘 안됀다
                _currentWidget = MyProgressIndicator();
            }
            //장면전환시 애니메이션을 넣을건데 consumer를 wrap으로 넣으면 안된다고했
            return AnimatedSwitcher(
              //디폴트로 페이드인 안웃으로 되어있음
              duration: Duration(milliseconds: 200),
              child: _currentWidget,
            );
          },
        ),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }
}
