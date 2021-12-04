import 'package:flutter/material.dart';

class ReviewDeckScreen extends StatefulWidget {
  const ReviewDeckScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReviewDeckScreenState();
  }
}

class _ReviewDeckScreenState extends State<ReviewDeckScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Review Decks'),
    );
  }
}
