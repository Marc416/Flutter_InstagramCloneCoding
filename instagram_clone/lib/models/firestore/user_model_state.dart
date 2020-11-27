import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/firestore/user_model.dart';

class UserModelState extends ChangeNotifier {
  UserModel _userModel;
  StreamSubscription<UserModel> _currentStreamSub;

  UserModel get userModel => _userModel;
  //새로 유저모델을 세팅해주면 상태변경!
  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  set currentStreamSub(StreamSubscription<UserModel> currentStreamSub) =>
      currentStreamSub = _currentStreamSub;

  //Stream 끊는부분
  clear(){
    if(_currentStreamSub != null){
      _currentStreamSub.cancel();
      _currentStreamSub = null;
      _userModel = null;
    }
  }
}
