import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';

//메소드를 다른 파일에서 접근하려면 메서드 앞의 언더바를 제거한다. '_method'->'method'

//텍스트폼필더의 데코의 Common 속성
InputDecoration textInputDecor(String hintText) {
  return InputDecoration(
    //텍스트폼필드안의 단어입력 : 이메일형식으로 쓰라 등등 문구적을 수 잇음
    hintText: hintText,
    enabledBorder: activeInputBorder(),
    focusedBorder: activeInputBorder(),
    //에러시 기본값이 밑줄인데 밑줄 속성을 아래와 같이 덮어버린
    focusedErrorBorder: errorInputBorder(),
    //에러일 때의 폼필드 아웃라인 속성.
    errorBorder: errorInputBorder(),
    filled: true,
    fillColor: Colors.grey[100],
  );
}

OutlineInputBorder activeInputBorder() {
  return OutlineInputBorder(
    //사각이 둥근 모양으로
      borderSide: BorderSide(color: Colors.grey[300]),
      borderRadius: BorderRadius.circular(common_s_gap));
}

OutlineInputBorder errorInputBorder() {
  return OutlineInputBorder(
    //사각이 둥근 모양으로
      borderSide: BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(common_s_gap));
}
