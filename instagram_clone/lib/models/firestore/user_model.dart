import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/constants/firestore_keys.dart';

class UserModel {
  final String userKey;
  final String profileImg;
  final String email;
  final List<dynamic> myPosts;
  final int followers;
  final List<dynamic> likedPosts;
  final String username;
  final List<dynamic> followings;
  final DocumentReference reference;

  //fromMap은 다트의 언어
  UserModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMIAL],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLWINGS],
        myPosts = map[KEY_MYPOSTS];

  //fromSnapShot  은 firestore의 언어.
  //레퍼런스에 어디에 뭐가있는지 나와있는것일거임
  //파이어스토어에서의 데이터를 가져오기위한 생성
  //collection - document - value
  //각가의 Document를 스냅샷이라 그런다
  UserModel.fromSnapShot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data(),
    snapshot.id,
    reference: snapshot.reference,
  );

  //유저생성시 사용 메서드
  static Map<String, dynamic> getMapForCreateUser(String email) {
    Map<String, dynamic> map = Map();
    map[KEY_PROFILEIMG] = '';
    //@으로 이메일을 나눈 리스트의 첫부
    map[KEY_USERNAME] = email.split('@')[0];
    map[KEY_EMIAL] = email;
    map[KEY_LIKEDPOSTS] = [];
    map[KEY_FOLLOWERS] = 0;
    map[KEY_FOLLWINGS] = [];
    map[KEY_MYPOSTS] = [];
    return map;
  }
}
