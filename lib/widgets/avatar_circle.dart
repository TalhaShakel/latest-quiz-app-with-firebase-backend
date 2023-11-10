import 'package:flutter/material.dart';
import 'package:quiz_app/utils/user_image.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({Key? key, required this.assetString, required this.size, required this.bgColor, this.imageUrl}) : super(key: key);

  final String? assetString;
  final String? imageUrl;
  final double size;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: size,
        width: size,
        
        decoration: BoxDecoration(
            // shape: BoxShape.circle,
            color: bgColor,
            image: getUserImage(context, imageUrl, assetString)),
      ),
    );
  }
}
