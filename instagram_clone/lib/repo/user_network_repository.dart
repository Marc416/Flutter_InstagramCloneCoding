import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/constants/firestore_keys.dart';
import 'package:instagram_clone/models/firestore/user_model.dart';
import 'package:instagram_clone/repo/helper/transformers.dart';

/// 파이어스토어의 데이터를 저장하거나 갱신하기위한 시스템.

class UserNetWorkRepository with Transformers {
  //로그인시도했는데? 유저가 없으면 유저를 db에 넣기
  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.set(UserModel.getMapForCreateUser(email));
    }
  }

  ///transform 은 스트림으로 data를 받기전에 마사지를해서 앱에서 쓰기좋은 형태로 만들기위한
  ///일종의 전처리메서드
  ///여기서는 snapshots 메서드로부터 'DocumentSnapShot'형태로 데이터가 받아와지는데
  ///이것을 Transform을 이용해 UserModel데이터형으로 바꿀것임
  Stream<UserModel> getUserModelStream(String userKey) {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser);
  }
}

//write Data
// Future<void> sendData() {
//   return FirebaseFirestore.instance
//       .collection('User')
//       .doc('123123')
//       .set({'userName': 'MyUserName'});
// }
//
// //read Data
// void getData() {
//   //아래에 get 을 하고 난 다음 얻는 데이터는 doc 의 데이터로 다받고 나면 출력하는 메서드임.
//   FirebaseFirestore.instance
//       .collection('User')
//       .doc('123123')
//       .get()
//       .then((doc) => print(doc.data()));
//}

// 여기에 생성시켜놔도 아무데서나 쓸수있음... 신기..
UserNetWorkRepository userNetWorkRepository = UserNetWorkRepository();
