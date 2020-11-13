import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.grey[300],
          height: 1,
        ),
        Container(
          color: Colors.grey[50],
          width: 60,
          height: 3,
        ),
        Text(
          'Or',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}