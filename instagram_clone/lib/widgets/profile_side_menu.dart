import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/models/firebase_auth_state.dart';
import 'package:instagram_clone/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class ProfileSideMenu extends StatelessWidget {
  final double menuWidth;

  const ProfileSideMenu(this.menuWidth, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.black87,
                ),
                title: Text('Sign Out'),
                onTap: () {
                  Provider.of<FirebaseAuthState>(context, listen: false)
                      .signOut();

                  ////밑의 구문은 페이지를 강제로 바꿔 주는 것임 ->프로바이더로 바꿔줘야함
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context) => AuthScreen(),),
                  // );
                })
          ],
        ),
      ),
    );
  }
}
