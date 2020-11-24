import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseAuthState extends ChangeNotifier {
  //처음 실행되면 이전의 이 사용자가 로그인했는 상태였는지 아닌지 체크해주기위해
  //프로그래스라고
  //첫 시작할 때 무슨 상태인지
  //외부에서 안전하게 쓰기위한 이걸 캡슐화라고 부르나?
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signout;
  User _firebaseUser;

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void watchAuthChange() {
    //스트림으로 파이어베이스 User데이터를 스트림으로 바뀔때마다 계속 받아 온다
    //Stream<User>라는 것은 User데이터를 넘겨준다는 것임
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (_firebaseUser == null && firebaseUser == null) {
        //내부의 user와 외부로부터 받아오는 user의 정보가 없다면 그냥 리턴
        return;
      } else if (_firebaseUser != firebaseUser) {
        _firebaseUser = firebaseUser;
        changeFireBaseAuthStatus();
      }
    });
  }

  //로그인
  void login(BuildContext context,{@required String email, @required String password}) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email.trim(), password: password.trim())
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
  }

  //아이디등록
  void registerUser(BuildContext context,
      {@required String email, @required String password}) {
    //trim =>  빈공간을 없애준다. 사용자들이 실수할 것을 메서드 내에서 처리
    _firebaseAuth
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
  }

  //로그아웃 할때
  void signOut() {
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      _firebaseAuth.signOut();
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
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    //상태변화됐으니까 프로바이더들에게 상태변화된 것을 알려주기.
    notifyListeners();
  }
}

enum FirebaseAuthStatus { signout, progoress, signin }
