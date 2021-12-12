import 'package:flutter/material.dart';
import 'package:memboost/View/manage_decks_screen.dart';
import 'package:memboost/View/profile_screen.dart';
import 'package:memboost/View/review_deck_screen.dart';

void main() {
  runApp(MemBoostApp());
}

class MemBoostApp extends StatelessWidget {
  MemBoostApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MemBoost', home: HomePage(), theme: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
    ));
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

  final homePageIconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('MemBoost'),
          actions: [
            Container(
                padding: const EdgeInsets.all(4),
                child: Image.asset("lib/assets/ic_app_icon.png",
                    height: homePageIconSize, width: homePageIconSize * 1.5))
          ],
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        )),
        body: PageView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
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
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                child: Image.asset("lib/assets/ic_homepage_boost!.png",
                    height: homePageIconSize, width: homePageIconSize),
              ),
              label: "Boost!",
            ),
            BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset("lib/assets/ic_homepage_decks.png",
                      height: homePageIconSize, width: homePageIconSize),
                ),
                label: "Decks"),
            BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset("lib/assets/ic_homepage_profile.png",
                      height: homePageIconSize, width: homePageIconSize),
                ),
                label: "Profile")
          ],
          onTap: _onTappedBar,
          selectedItemColor: Colors.blue,
          currentIndex: _selectedIndex,
        ));
  }

  void _onTappedBar(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
    _pageController.jumpToPage(newIndex);
  }
}
