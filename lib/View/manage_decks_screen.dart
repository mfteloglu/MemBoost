import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(tabs: [Tab(text: "My Decks"), Tab(text: "Browse Decks")]),
            ],
          )),
          body: TabBarView(
            children: [MyDecksTab(), BrowseDecksTab()],
          ),
        ));
  }
}

class MyDecksTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDecksTab();
  }
}

class _MyDecksTab extends State<MyDecksTab> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
        Deck(),
      ],
    );
  }
}

class BrowseDecksTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseDecksTab();
  }
}

class _BrowseDecksTab extends State<BrowseDecksTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
            Deck(),
          ]),
      buildFloatingSearchBar()
    ]);
  }
}

Widget buildFloatingSearchBar() {
  final isPortrait = true;

  return FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}

class Deck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Text("Deck"),
      color: Colors.teal[100],
    );
  }
}
