
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/common_size.dart';

class RoundedAvatar extends StatelessWidget {
  final double size;

  const RoundedAvatar({
    Key key, this.size = avatar_size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
//        가로세로가 모두 100인 아무 이미지나 가져올것임
        imageUrl: 'https://picsum.photos/100',
        width: size,
        height: size,
      ),
    );
  }
}
