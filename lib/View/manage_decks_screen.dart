import 'package:flutter/material.dart';

class ManageDecksScreen extends StatefulWidget {
  const ManageDecksScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManageDecksScreenState();
  }
}

class _ManageDecksScreenState extends State<ManageDecksScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Manage Decks'),
    );
  }
}
