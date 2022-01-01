import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:memboost/ClassModels/deck.dart';
import 'package:memboost/ViewModel/decks_view_model.dart';
import 'package:provider/provider.dart';

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

  List<DeckTileDownloaded> decks = [];

  void buildDeckTilesFromDecks(List<Deck> deckModels) {
    decks = [];
    for (var deckModel in deckModels) {
      decks.add(DeckTileDownloaded(
        deckModel,
        key: UniqueKey(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<DecksViewModel>(context, listen: false).getDownloadedDecks();
    return Consumer<DecksViewModel>(builder: (context, viewModel, child) {
      buildDeckTilesFromDecks(viewModel.downloadedDecks);
      return GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [...decks],
      );
    });
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

  List<String> decks = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<DecksViewModel>(context, listen: false)
        .getListOfDecksOnServer();
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 600, height: 54, child: buildFloatingSearchBar()),
          Consumer<DecksViewModel>(builder: (context, viewModel, child) {
            decks = viewModel.decksOnServer;
            return Expanded(
              child: GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (var deck in decks)
                      DeckTileOnBackend(deck.toString(), key: UniqueKey()),
                    // list all decks in storage
                  ]),
            );
          })
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

class DeckTileDownloaded extends StatelessWidget {
  const DeckTileDownloaded(this.deck, {Key? key}) : super(key: key);
  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(deck.name!),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        IconButton(
                          alignment: Alignment.bottomRight,
                          icon: const Icon(Icons.select_all),
                          onPressed: () {
                            Provider.of<DecksViewModel>(context, listen: false)
                                .selectDeckToBeReviewed(deck);
                          },
                        ),
                        IconButton(
                          alignment: Alignment.bottomRight,
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Provider.of<DecksViewModel>(context, listen: false)
                                .deleteDeck(deck.name!);
                          },
                        )
                      ],
                    )))
          ]),
      color: Colors.teal[100],
    );
  }
}

class DeckTileOnBackend extends StatelessWidget {
  const DeckTileOnBackend(this.name, {Key? key}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        Provider.of<DecksViewModel>(context, listen: false)
                            .downloadDeck(name);
                      },
                    )))
          ]),
      color: Colors.teal[100],
    );
  }
}
