import 'package:flutter/material.dart';
import 'package:memboost/View/manage_decks_screen.dart';
import 'package:memboost/View/profile_screen.dart';
import 'package:memboost/View/review_deck_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'MemBoost', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go!'),
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: const <Widget>[
          ReviewDeckScreen(),
          ManageDecksScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Boost!"),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: "Decks"),
          BottomNavigationBarItem(icon: Icon(Icons.eleven_mp), label: "Profile")
        ],
        onTap: _onTappedBar,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onTappedBar(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
    _pageController.jumpToPage(newIndex);
  }
}
