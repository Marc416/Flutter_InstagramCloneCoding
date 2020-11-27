import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:instagram_clone/repo/user_network_repository.dart';
import 'package:instagram_clone/utils/simple_snackbar.dart';

class FirebaseAuthState extends ChangeNotifier {
  //처음 실행되면 이전의 이 사용자가 로그인했는 상태였는지 아닌지 체크해주기위해
  //프로그래스라고
  //첫 시작할 때 무슨 상태인지
  //외부에서 안전하게 쓰기위한 이걸 캡슐화라고 부르나?
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progoress;
  User _firebaseUser;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FacebookLogin _facebookLogin;

  void watchAuthChange() {
    ///스트림으로 파이어베이스 User데이터를 스트림으로 바뀔때마다 계속 받아 온다
    ///Stream<User>라는 것은 User데이터를 넘겨준다는 것임
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (_firebaseUser == null && firebaseUser == null) {
        ///처음에 파이어베이스로부터 받는 user 정보가 null 이기 때문에 Progress 상태에서
        ///Sign out 상태로 바꿔주기 위함.
        changeFireBaseAuthStatus();
      } else if (_firebaseUser != firebaseUser) {
        _firebaseUser = firebaseUser;
        changeFireBaseAuthStatus();
      }
    });
  }
///region 로그인
  //페이스북 로그인
  void loginWithFacebook(BuildContext context) async {
    if (_facebookLogin == null) _facebookLogin = FacebookLogin();
    final result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _handleFacebookTokenWithFirebase(context, result.accessToken.token);
        simpleSnackBar(context, '로그인 되었습니다 잠시만 기다려주세요.');
        break;
      case FacebookLoginStatus.cancelledByUser:
        simpleSnackBar(context, '유저에의해다 로그인 취소되었습니다 ');
        break;
      case FacebookLoginStatus.error:
        simpleSnackBar(context, '페이스북 로그인 에러입니다');
        print('에러');
        //다른 아이디로 로그인되어 있을 수도 있으니까 시스템에서 로그아웃 해준다
        _facebookLogin.logOut();
        // TODO: Handle this case.
        break;
    }
  }
/// endregion
  void _handleFacebookTokenWithFirebase(
      BuildContext context, String token) async {
    //토큰을 사용해서 파이어베이스로 로그인하기
    //페이스북에서 받은 토큰을 파이어베이스 어스로 넘길 형태로 변환
    final AuthCredential credential = FacebookAuthProvider.credential(token);
    //파이어베이스에 토큰 넘기기
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = userCredential.user;

    if (user == null) {
      simpleSnackBar(context, '페이스북 로그인이 실패하였습니다 나중에 다시해 주세');
    } else {
      //유저가 잘들어가 있고 잘 되었다면 로그인가능하게 하라
      _firebaseUser = user;
    }
    notifyListeners();
  }

  //로그인

  void login(BuildContext context,
      {@required String email, @required String password}) async{
    //로그인 중 프로그래스 바 실행해서 안심심하게 해주기
    changeFireBaseAuthStatus(FirebaseAuthStatus.progoress);
    UserCredential authResult = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      String _message = '오류입니다';
      switch (error.code) {
        case 'invalid-email':
          _message = '유효하지 않은 이메일 입니다';
          break;
        case 'user-disabled':
          _message = '차단된 사용자입니다.';
          break;
        case 'user-not-found':
          _message = '없는 이메일 입니다';
          break;
        case 'wrong-password':
          _message = '비밀번호가 틀렸습니다';
          break;
      }
      SnackBar snackBar = SnackBar(content: Text(_message));
      Scaffold.of(context).showSnackBar(snackBar);
    });

    _firebaseUser = authResult.user;
    //유저가 있는지 없는지 확인후
    if (_firebaseUser == null) {
      SnackBar snackBar = SnackBar(
          content: Text(
            '오류가 떴으니 나중에 다시해주세',
          ));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
// endregion
  //아이디등록
  void registerUser(BuildContext context,
      {@required String email, @required String password}) async {
    changeFireBaseAuthStatus(FirebaseAuthStatus.progoress);
    //trim =>  빈공간을 없애준다. 사용자들이 실수할 것을 메서드 내에서 처리
    //createUserWithEmailAndPassword 의 리턴 정보를 userCredential에 가져온다 민감한 정보
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      //에러캐치해서 스낵바 실행시키기
      String _message = '오류입니';
      print(error.code);
      switch (error.code) {
        case 'email-already-in-use':
          print('사용중');
          _message = '해당 아이디는 이미 사용중입니다';
          break;
        case 'invalid-email':
          _message = '이메일 형식이 아닙니다';
          break;
        case 'operation-not-allowed':
          _message = '아이디나 비밀번호가 일치하지않습니다';
          break;
      }
      SnackBar snackBar = SnackBar(
          content: Text(
        _message,
        style: TextStyle(color: Colors.white),
      ));
      Scaffold.of(context).showSnackBar(snackBar);
    });
    //로그인, 회원가입시 에러메시지를 스낵바로보내기- 스낵바의 컨텍스트는 반드시 scaffold 것을 써야 한다.

    _firebaseUser = authResult.user;
    //유저가 있는지 없는지 확인후
    if (_firebaseUser == null) {
      SnackBar snackBar = SnackBar(
          content: Text(
        '오류가 떴으니 나중에 다시해주세',
      ));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      await userNetWorkRepository.attemptCreateUser(
          userKey: firebaseUser.uid, email: firebaseUser.email);
    }
  }

  //로그아웃 할때
  void signOut() async {
    changeFireBaseAuthStatus(FirebaseAuthStatus.progoress);
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      await _firebaseAuth.signOut();
      //페이스북로그인이 되어 있다면 로그아웃 시키
      if (await _facebookLogin.isLoggedIn) {
        await _facebookLogin.logOut();
      }
    }
    notifyListeners();
  }

//함수 매개변수를 '[ ]'로 감싸면 해당매개변수는 옵션이라는 뜻
  void changeFireBaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      //매개변수로 받은 변수에 status변수가 null이아니면 private변수인 status변수를 바꿔준다.
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        //유저의 데이터가 있다면 로그인된상태이므로 status를 로그인으로 바꿔주
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        ///유저정보를 받지 못했을 경우 또는 없는 경우
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    //상태변화됐으니까 프로바이더들에게 상태변화된 것을 알려주기.
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
  User get firebaseUser =>_firebaseUser;
}

enum FirebaseAuthStatus { signout, progoress, signin }
