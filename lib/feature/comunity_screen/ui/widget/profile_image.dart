import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImageDesign extends StatelessWidget {
  const ProfileImageDesign({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/ProfileScreen',
        );
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}
