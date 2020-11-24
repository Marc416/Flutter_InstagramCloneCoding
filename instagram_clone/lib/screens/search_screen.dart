import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';
import 'package:instagram_clone/widgets/rounded_avatar.dart';
import 'package:path/path.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Listgenerate는 왜 쓰는 것일까..그냥 false로 다 줘도 되는거 아닌
  List<bool> following = List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              //if문 안쓰고 바로바꾸니까 더 깔끔하고 좋은듯
              setState(() {
                following[index] = !following[index];
              });
            },
            leading: RoundedAvatar(),
            title: Text('username $index'),
            subtitle: Text('userbionumber $index'),
            trailing: Container(
              alignment: Alignment.center,
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                color: following[index] ? Colors.blue[50] : Colors.red[50],
                border: Border.all(
                  color: following[index] ? Colors.blue : Colors.red,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'following',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
          );
        },
        itemCount: following.length,
      ),
    );
  }
}
