import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/firestore/user_model.dart';

class Transformers {
  ///DocumentSnapshot을 넣고 UserModel로 바꿔 준다는 뜻인거 같은데.. 아래와 같은
  ///형태일 때 한글로 해석하면 어떻게 해야 하는건지...
  ///메서드를 변수로 지정해서 사용할거임
  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(

      ///손볼 데이터 어떻게 손볼건지
      handleData: (snapshot, sink) async {
    ///싱크에 마사지한 데이터를 넣기
    ///여기서는 fromSnapShot메서드로 우리가 미리 만든 자료구조형으로 바꿔서 sink에 넣어둔다
    sink.add(UserModel.fromSnapShot(snapshot));
  });
}
