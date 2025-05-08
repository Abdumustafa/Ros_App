import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LikeButton extends StatefulWidget {
  final int initialCount;
  const LikeButton({super.key, required this.initialCount});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLike,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/like_icon.svg',
            height: 18,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          SizedBox(width: 4),
          Text(
            ' $likeCount     ',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
