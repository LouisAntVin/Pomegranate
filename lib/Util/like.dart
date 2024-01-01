import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function() onTap;

  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ), // Icon Icons.favorite_border, Colors.red Colors.grey,
    ); // GestureDetector
  }
}

class SaveButton extends StatelessWidget {
  final bool isSaved;
  void Function() onTap;

  SaveButton({super.key, required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
      ),
    );
  }
}
