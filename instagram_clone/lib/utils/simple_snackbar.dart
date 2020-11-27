import 'package:flutter/material.dart';

void simpleSnackBar(BuildContext context, String s) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(s),
    ),
  );
}
