import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:memboost/ClassModels/deck.dart';
import 'package:memboost/View/create_new_deck_dialog.dart';
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

  void createNewDeck() {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return CreateNewDeckDialog(key: UniqueKey());
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<DecksViewModel>(context, listen: false).getDownloadedDecks();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewDeck();
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<DecksViewModel>(builder: (context, viewModel, child) {
        buildDeckTilesFromDecks(viewModel.downloadedDecks);
        return GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [...decks],
        );
      }),
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

  final _searchBarTextController = TextEditingController();
  final focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  List<String> decks = [];
  List<String> searchResultDecks = [];

  void search(String value) {
    searchResultDecks.clear();
    if (value.isEmpty) {
      focusNode.unfocus();
      searchResultDecks = decks.toList();
      return;
    }
    for (var deck in decks) {
      if (deck.toLowerCase().contains(value.toLowerCase())) {
        searchResultDecks.add(deck);
      }
    }
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<DecksViewModel>(context, listen: false)
        .getListOfDecksOnServer();
    return RefreshIndicator(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 600,
                  height: 65,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black45,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 90,
                                child: TextField(
                                  onSubmitted: (str) {
                                    focusNode.unfocus();
                                  },
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                    ),
                                  ),
                                  showCursor: false,
                                  controller: _searchBarTextController,
                                  onChanged: (value) {
                                    search(value);
                                    setState(() {});
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: _searchBarTextController.text.isEmpty
                                    ? const Icon(Icons.search)
                                    : Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          splashRadius: 1,
                                          alignment: Alignment.topCenter,
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            focusNode.unfocus();
                                            _searchBarTextController.clear();
                                            search("");
                                            setState(() {});
                                          },
                                        ),
                                      ),
                              )
                            ],
                          )),
                    ),
                  )),
              Consumer<DecksViewModel>(builder: (context, viewModel, child) {
                decks = viewModel.decksOnServer;
                search(_searchBarTextController.text);
                print("build");
                return Expanded(
                  child: GridView.count(
                      padding: const EdgeInsets.all(10),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        for (var deck in searchResultDecks)
                          DeckTileOnBackend(deck.toString(), key: UniqueKey()),
                        // list all decks in storage
                      ]),
                );
              })
            ]),
        onRefresh: () async {
          Provider.of<DecksViewModel>(context, listen: false)
              .getListOfDecksOnServer();
        });
  }
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
