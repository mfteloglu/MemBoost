import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:memboost/Model/Model.dart';

class ManageDecksScreen extends StatefulWidget {
  const ManageDecksScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManageDecksScreenState();
  }
}

class _ManageDecksScreenState extends State<ManageDecksScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                      indicatorColor: Theme.of(context).colorScheme.secondary,
                      tabs: const [
                        Tab(text: "My Decks"),
                        Tab(text: "Browse Decks")
                      ]),
                ],
              )),
          body: const TabBarView(
            children: [MyDecksTab(), BrowseDecksTab()],
          ),
        ));
  }
}

class MyDecksTab extends StatefulWidget {
  const MyDecksTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyDecksTab();
  }
}

class _MyDecksTab extends State<MyDecksTab> with AutomaticKeepAliveClientMixin {
  final isServer = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        Deck("German 101", isServer),
        Deck("English Words", isServer),
        Deck("Bones", isServer),
        Deck("Muscles", isServer),
        Deck("German Animals", isServer),
      ],
    );
  }
}

class BrowseDecksTab extends StatefulWidget {
  const BrowseDecksTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BrowseDecksTab();
  }
}

class _BrowseDecksTab extends State<BrowseDecksTab>
    with AutomaticKeepAliveClientMixin {
  final isServer = true;

  @override
  bool get wantKeepAlive => true;

  // fetch all decks from storage
  List<String> allDecks = [];

  initState() {
    startAsyncInit();
  }

  Future startAsyncInit() async {
    allDecks = await listAllDecks();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 600, height: 54, child: buildFloatingSearchBar()),
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(10),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var i in allDecks) Deck('${i.toString()}', isServer),
                  // list all decks in storage
                  Deck("English Words", isServer),
                  Deck("Bones", isServer),
                  Deck("Muscles", isServer),
                  Deck("German Animals", isServer),
                  Deck("Tree Names", isServer),
                  Deck("Organs", isServer),
                  Deck("Bacterias", isServer),
                  Deck("Spanish furniture", isServer),
                ]),
          )
        ]);
  }
}

Widget buildFloatingSearchBar() {
  const isPortrait = true;

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
          icon: const Icon(Icons.search),
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
  const Deck(this.text, this.isServer, {Key? key}) : super(key: key);
  final String text;
  final bool isServer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(text),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: isServer
                        ? const Icon(Icons.download)
                        : const Icon(Icons.settings)))
          ]),
      color: Colors.teal[100],
    );
  }
}
