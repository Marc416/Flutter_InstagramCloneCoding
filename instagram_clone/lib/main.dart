import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/material_white.dart';
import 'package:instagram_clone/models/firebase_auth_state.dart';
import 'package:instagram_clone/models/firestore/user_model_state.dart';
import 'package:instagram_clone/repo/user_network_repository.dart';
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

  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _fireBaseAuthState.watchAuthChange();

    ///멀티프로바이더 : 두개이상의 프로바이더를 사용해야할 때! 두개모두 변화가 필요할 때
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
          value: _fireBaseAuthState,
        ),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(
          builder: (context, firebaseAuthState, child) {
            switch (firebaseAuthState.firebaseAuthStatus) {
              case FirebaseAuthStatus.signout:
                _clearUserModel(context);
                _currentWidget = AuthScreen();
                break;
              case FirebaseAuthStatus.signin:
                _initUserModel(firebaseAuthState, context);
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

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);

    userModelState.currentStreamSub = userNetWorkRepository
        .getUserModelStream(firebaseAuthState.firebaseUser.uid)
        .listen((userModel) {
      ///리슨하면 유저의 먼가가 변화할 때마다 계속 업데이트 될것임
      /// notifyListener 같이 리스너가 있으면 Listen: false 해줘야함음
      /// getter는 NotifyLister()가 없으므로 리스너 제약을 안해도 상관이 없
      Provider.of<UserModelState>(context, listen: false).userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}
